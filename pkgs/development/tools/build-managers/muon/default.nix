{ lib
, stdenv
, fetchFromSourcehut
, fetchurl
, curl
, libarchive
, libpkgconf
, pkgconf
, python3
, samurai
, scdoc
, zlib
, embedSamurai ? false
, buildDocs ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "muon"
          + lib.optionalString embedSamurai "-embedded-samurai";
  version = "0.1.0";

  src = fetchFromSourcehut {
    name = "muon-src";
    owner = "~lattis";
    repo = "muon";
    rev = finalAttrs.version;
    hash = "sha256-m382/Y+qOYk7hHdDdOpiYWNWrqpnWPCG4AKGGkmLt4o=";
  };

  outputs = [ "out" ] ++ lib.optionals buildDocs [ "man" ];

  nativeBuildInputs = [
    pkgconf
    samurai
  ]
  ++ lib.optionals buildDocs [
    (python3.withPackages (ps: [ ps.pyyaml ]))
    scdoc
  ];

  buildInputs = [
    curl
    libarchive
    libpkgconf
    samurai
    zlib
  ];

  strictDeps = true;

  postUnpack = let
    # URLs manually extracted from subprojects directory
    meson-docs-wrap = fetchurl {
      name = "meson-docs-wrap";
      url = "https://mochiro.moe/wrap/meson-docs-0.63.0-239-g41a05ff93.tar.gz";
      hash = "sha256-wg2mDkrkE1xVNXJf4sVm6cN1ozVeDbbw0CBYtixg5/Q=";
    };

    samurai-wrap = fetchurl {
      name = "samurai-wrap";
      url = "https://mochiro.moe/wrap/samurai-1.2-28-g4e3a595.tar.gz";
      hash = "sha256-TZAEwndVgoWr/zhykfr0wcz9wM96yG44GfzM5p9TpBo=";
  };
  in ''
    pushd $sourceRoot/subprojects
    ${lib.optionalString buildDocs "tar xvf ${meson-docs-wrap}"}
    ${lib.optionalString embedSamurai "tar xvf ${samurai-wrap}"}
    popd
  '';

  postPatch = ''
    patchShebangs bootstrap.sh
  ''
  + lib.optionalString buildDocs ''
    patchShebangs subprojects/meson-docs/docs/genrefman.py
  '';

  # tests try to access "~"
  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

  buildPhase = let
    muonBool = lib.mesonBool;
    muonEnable = lib.mesonEnable;

    cmdlineForMuon = lib.concatStringsSep " " [
      (muonBool "static" stdenv.targetPlatform.isStatic)
      (muonEnable "docs" buildDocs)
      (muonEnable "samurai" embedSamurai)
    ];
    cmdlineForSamu = "-j$NIX_BUILD_CORES";
  in ''
    runHook preBuild

    ./bootstrap.sh stage-1

    ./stage-1/muon setup ${cmdlineForMuon} stage-2
    samu ${cmdlineForSamu} -C stage-2

    stage-2/muon setup -Dprefix=$out ${cmdlineForMuon} stage-3
    samu ${cmdlineForSamu} -C stage-3

    runHook postBuild
  '';

  # tests are failing because they don't find Python
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    ./stage-3/muon -C stage-3 test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    stage-3/muon -C stage-3 install

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://muon.build/";
    description = "An implementation of Meson build system in C99";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # typical `ar failure`
  };
})
# TODO LIST:
# 1. automate sources acquisition (especially wraps)
# 2. setup hook
# 3. tests
