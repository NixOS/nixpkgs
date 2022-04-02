{ stdenv
, lib
, fetchurl

, uasm
, useUasm ? stdenv.isx86_64

  # RAR code is under non-free unRAR license
  # see the meta.license section below for more details
, enableUnfree ? false
}:

let
  inherit (stdenv.hostPlatform) system;
  platformSuffix =
    if useUasm then
      {
        x86_64-linux = "_x64";
      }.${system} or (throw "`useUasm` is not supported for system ${system}")
    else "";
in
stdenv.mkDerivation rec {
  pname = "7zz";
  version = "21.07";

  src = fetchurl {
    url = "https://7-zip.org/a/7z${lib.replaceStrings [ "." ] [ "" ] version}-src.tar.xz";
    sha256 = {
      free = "sha256-SMM6kQ6AZ05s4miJjMoE4NnsXQ0tlkdWx0q2HKjhaM8=";
      unfree = "sha256-IT1ZRAfLjvy6NmELFSykkh7aFBYzELQ5A9E+aDE+Hjk=";
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

  sourceRoot = "CPP/7zip/Bundles/Alone2";

  makeFlags =
    lib.optionals useUasm [ "MY_ASM=uasm" ] ++
    # it's the compression code with the restriction, see DOC/License.txt
    lib.optionals (!enableUnfree) [ "DISABLE_RAR_COMPRESS=true" ];

  makefile = "../../cmpl_gcc${platformSuffix}.mak";

  nativeBuildInputs = lib.optionals useUasm [ uasm ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin b/g${platformSuffix}/7zz
    install -Dm444 -t $out/share/doc/${pname} ../../../../DOC/*.txt

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/7zz --help | grep ${version}

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

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
    platforms = platforms.linux;
    mainProgram = "7zz";
  };
}
