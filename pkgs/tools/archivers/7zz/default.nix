{ stdenv
, lib
, fetchurl

  # Only used for Linux's x86/x86_64
, uasm
, useUasm ? (stdenv.isLinux && stdenv.hostPlatform.isx86)

  # RAR code is under non-free unRAR license
  # see the meta.license section below for more details
, enableUnfree ? false

  # For tests
, _7zz
, testers
}:

let
  makefile = {
    aarch64-darwin = "../../cmpl_mac_arm64.mak";
    x86_64-darwin = "../../cmpl_mac_x64.mak";
    aarch64-linux = "../../cmpl_gcc_arm64.mak";
    i686-linux = "../../cmpl_gcc_x86.mak";
    x86_64-linux = "../../cmpl_gcc_x64.mak";
  }.${stdenv.hostPlatform.system} or "../../cmpl_gcc.mak"; # generic build
in
stdenv.mkDerivation rec {
  pname = "7zz";
  version = "22.01";

  src = fetchurl {
    url = "https://7-zip.org/a/7z${lib.replaceStrings [ "." ] [ "" ] version}-src.tar.xz";
    hash = {
      free = "sha256-mp3cFXOEiVptkUdD1+X8XxwoJhBGs+Ns5qk3HBByfLg=";
      unfree = "sha256-OTCYcwxwBCOSr4CJF+dllF3CQ33ueq48/MSWbrkg+8U=";
    }.${if enableUnfree then "unfree" else "free"};
    downloadToTemp = (!enableUnfree);
    # remove the unRAR related code from the src drv
    # > the license requires that you agree to these use restrictions,
    # > or you must remove the software (source and binary) from your hard disks
    # https://fedoraproject.org/wiki/Licensing:Unrar
    postFetch = lib.optionalString (!enableUnfree) ''
      mkdir tmp
      tar xf $downloadedFile -C ./tmp
      rm -r ./tmp/CPP/7zip/Compress/Rar*
      tar cfJ $out -C ./tmp . \
        --sort=name \
        --mtime="@$SOURCE_DATE_EPOCH" \
        --owner=0 --group=0 --numeric-owner \
        --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime
    '';
  };

  sourceRoot = ".";

  patches = [
    ./fix-build-on-darwin.patch
    ./fix-cross-mingw-build.patch
  ];
  patchFlags = [ "-p0" ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMinGW ''
    substituteInPlace CPP/7zip/7zip_gcc.mak C/7zip_gcc_c.mak \
      --replace windres.exe ${stdenv.cc.targetPrefix}windres
  '';

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-Wno-deprecated-copy-dtor"
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    "-Wno-conversion"
    "-Wno-unused-macros"
  ]);

  inherit makefile;

  makeFlags =
    [
      "CC=${stdenv.cc.targetPrefix}cc"
      "CXX=${stdenv.cc.targetPrefix}c++"
    ]
    ++ lib.optionals useUasm [ "MY_ASM=uasm" ]
    # We need at minimum 10.13 here because of utimensat, however since
    # we need a bump anyway, let's set the same minimum version as the one in
    # aarch64-darwin so we don't need additional changes for it
    ++ lib.optionals stdenv.isDarwin [ "MACOSX_DEPLOYMENT_TARGET=10.16" ]
    # it's the compression code with the restriction, see DOC/License.txt
    ++ lib.optionals (!enableUnfree) [ "DISABLE_RAR_COMPRESS=true" ]
    ++ lib.optionals (stdenv.hostPlatform.isMinGW) [ "IS_MINGW=1" "MSYSTEM=1" ];

  nativeBuildInputs = lib.optionals useUasm [ uasm ];

  enableParallelBuilding = true;

  preBuild = "cd CPP/7zip/Bundles/Alone2";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin b/*/7zz${stdenv.hostPlatform.extensions.executable}
    install -Dm444 -t $out/share/doc/${pname} ../../../../DOC/*.txt

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = _7zz;
      command = "7zz --help";
    };
  };

  meta = with lib; {
    description = "Command line archiver utility";
    homepage = "https://7-zip.org";
    license = with licenses;
      # 7zip code is largely lgpl2Plus
      # CPP/7zip/Compress/LzfseDecoder.cpp is bsd3
      [ lgpl2Plus /* and */ bsd3 ] ++
      # and CPP/7zip/Compress/Rar* are unfree with the unRAR license restriction
      # the unRAR compression code is disabled by default
      lib.optionals enableUnfree [ unfree ];
    maintainers = with maintainers; [ anna328p peterhoeg jk ];
    platforms = platforms.unix ++ platforms.windows;
    mainProgram = "7zz";
  };
}
