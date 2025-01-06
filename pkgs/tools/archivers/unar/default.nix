{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, gnustep
, bzip2
, zlib
, icu
, openssl
, wavpack
, xcbuildHook
, Foundation
, AppKit
}:

stdenv.mkDerivation rec {
  pname = "unar";
  version = "1.10.8";

  srcs = [
    (fetchFromGitHub rec {
      owner = "MacPaw";
      repo = "XADMaster";
      name = repo;
      rev = "v${version}";
      hash = "sha256-dmIyxpa3pq4ls4Grp0gy/6ZjcaA7rmobMn4h1inVgns=";
    })
    (fetchFromGitHub {
      owner = "MacPaw";
      repo = "universal-detector";
      name = "UniversalDetector";
      rev = "1.1";
      hash = "sha256-6X1HtXhRuRwBOq5TAtL1I/vBBZokZOXIQ+oaRFigtv8=";
    })
  ];

  postPatch = ''
      substituteInPlace unar.m lsar.m \
        --replace-fail "v1.10.7" "v${version}"
    '' + (if stdenv.hostPlatform.isDarwin then ''
      substituteInPlace "./XADMaster.xcodeproj/project.pbxproj" \
        --replace "libstdc++.6.dylib" "libc++.1.dylib"
    '' else ''
      for f in Makefile.linux ../UniversalDetector/Makefile.linux ; do
        substituteInPlace $f \
          --replace "= gcc" "=${stdenv.cc.targetPrefix}cc" \
          --replace "= g++" "=${stdenv.cc.targetPrefix}c++" \
          --replace "-DGNU_RUNTIME=1" "" \
          --replace "-fgnu-runtime" "-fobjc-runtime=gnustep-2.0"
      done

      # we need to build inside this directory as well, so we have to make it writeable
      chmod +w ../UniversalDetector -R
    '');

  buildInputs = [ bzip2 icu openssl wavpack zlib ] ++
    lib.optionals stdenv.hostPlatform.isLinux [ gnustep.base ] ++
    lib.optionals stdenv.hostPlatform.isDarwin [ Foundation AppKit ];

  nativeBuildInputs = [ installShellFiles ] ++
    lib.optionals stdenv.hostPlatform.isLinux [ gnustep.make ] ++
    lib.optionals stdenv.hostPlatform.isDarwin [ xcbuildHook ];

  xcbuildFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-target unar"
    "-target lsar"
    "-configuration Release"
    "MACOSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
  ];

  makefile = lib.optionalString (!stdenv.hostPlatform.isDarwin) "Makefile.linux";

  enableParallelBuilding = true;

  dontConfigure = true;

  sourceRoot = "XADMaster";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin ${lib.optionalString stdenv.hostPlatform.isDarwin "Products/Release/"}{lsar,unar}
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
