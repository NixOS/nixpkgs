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
  version = "unstable-2022-09-24";

  src = fetchFromSourcehut {
    name = "muon-src";
    owner = "~lattis";
    repo = "muon";
    rev = "f385c82a6104ea3341ca34756e2812d700bc43d8";
    hash = "sha256-Cr1r/sp6iVotU+n4bTzQiQl8Y+ShaqnnaWjL6gRW8p0=";
  };

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
      url = "https://mochiro.moe/wrap/meson-docs-0.63.0-116-g8a45c81cf.tar.gz";
      hash = "sha256-fsXdhfBEXvw1mvqnPp2TgZnO5FaeHTNW3Nfd5qfTfxg=";
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
    featureFlag = feature: flag:
      "-D${feature}=${if flag then "enabled" else "disabled"}";
    conditionFlag = condition: flag:
      "-D${condition}=${lib.boolToString flag}";
    cmdlineForMuon = lib.concatStringsSep " " [
      (conditionFlag "static" stdenv.targetPlatform.isStatic)
      (featureFlag "docs" buildDocs)
      (featureFlag "samurai" embedSamurai)
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
# 1. setup hook
# 2. multiple outputs
# 3. automate sources acquisition (especially wraps)
# 4. tests
