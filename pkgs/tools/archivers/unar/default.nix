{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  gnustep,
  bzip2,
  zlib,
  icu,
  openssl,
  wavpack,
  xcbuildHook,
  Foundation,
  AppKit,
}:

stdenv.mkDerivation rec {
  pname = "unar";
  version = "1.10.7";

  src = fetchFromGitHub {
    owner = "MacPaw";
    # the unar repo contains a shallow clone of both XADMaster and universal-detector
    repo = "unar";
    rev = "v${version}";
    sha256 = "0p846q1l66k3rnd512sncp26zpv411b8ahi145sghfcsz9w8abc4";
  };

  postPatch =
    if stdenv.isDarwin then
      ''
        substituteInPlace "./XADMaster.xcodeproj/project.pbxproj" \
          --replace "libstdc++.6.dylib" "libc++.1.dylib"
      ''
    else
      ''
        for f in Makefile.linux ../UniversalDetector/Makefile.linux ; do
          substituteInPlace $f \
            --replace "= gcc" "=${stdenv.cc.targetPrefix}cc" \
            --replace "= g++" "=${stdenv.cc.targetPrefix}c++" \
            --replace "-DGNU_RUNTIME=1" "" \
            --replace "-fgnu-runtime" "-fobjc-runtime=gnustep-2.0"
        done

        # we need to build inside this directory as well, so we have to make it writeable
        chmod +w ../UniversalDetector -R
      '';

  buildInputs =
    [
      bzip2
      icu
      openssl
      wavpack
      zlib
    ]
    ++ lib.optionals stdenv.isLinux [ gnustep.base ]
    ++ lib.optionals stdenv.isDarwin [
      Foundation
      AppKit
    ];

  nativeBuildInputs = [
    installShellFiles
  ] ++ lib.optionals stdenv.isLinux [ gnustep.make ] ++ lib.optionals stdenv.isDarwin [ xcbuildHook ];

  xcbuildFlags = lib.optionals stdenv.isDarwin [
    "-target unar"
    "-target lsar"
    "-configuration Release"
    "MACOSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
  ];

  makefile = lib.optionalString (!stdenv.isDarwin) "Makefile.linux";

  enableParallelBuilding = true;

  dontConfigure = true;

  sourceRoot = "${src.name}/XADMaster";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin ${lib.optionalString stdenv.isDarwin "Products/Release/"}{lsar,unar}
    for f in lsar unar; do
      installManPage ./Extra/$f.?
      installShellCompletion --bash --name $f ./Extra/$f.bash_completion
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://theunarchiver.com";
    description = "Archive unpacker program";
    longDescription = ''
      The Unarchiver is an archive unpacker program with support for the popular
      zip, RAR, 7z, tar, gzip, bzip2, LZMA, XZ, CAB, MSI, NSIS, EXE, ISO, BIN,
      and split file formats, as well as the old Stuffit, Stuffit X, DiskDouble,
      Compact Pro, Packit, cpio, compress (.Z), ARJ, ARC, PAK, ACE, ZOO, LZH,
      ADF, DMS, LZX, PowerPacker, LBR, Squeeze, Crunch, and other old formats.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "unar";
    platforms = platforms.unix;
  };
}
