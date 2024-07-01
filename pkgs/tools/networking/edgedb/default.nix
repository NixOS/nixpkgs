{
  stdenv,
  lib,
  patchelf,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  curl,
  Security,
  CoreServices,
  libiconv,
  xz,
  perl,
  substituteAll,
  # for passthru.tests:
  edgedb,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "edgedb";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev = "v${version}";
    hash = "sha256-znxAtfSeepLQqkPsEzQBp3INZym5BLap6m29C/9z+h8=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "edgedb-derive-0.5.1" = "sha256-ATldvarkp/W5bz55qoMtfTMcueWklyKnrJUHvLKlWh0=";
      "edgeql-parser-0.1.0" = "sha256-KPi2M2UEN+p3V/fcmKtb3K9XTLC4vJ5H+yG8ZfD7RBs=";
      "indexmap-2.0.0-pre" = "sha256-QMOmoUHE1F/sp+NeDpgRGqqacWLHWG02YgZc5vAdXZY=";
      "rexpect-0.5.0" = "sha256-vstAL/fJWWx7WbmRxNItKpzvgGF3SvJDs5isq9ym/OA=";
      "rustyline-8.0.0" = "sha256-CrICwQbHPzS4QdVIEHxt2euX+g+0pFYe84NfMp1daEc=";
      "serde_str-1.0.0" = "sha256-CMBh5lxdQb2085y0jc/DrV6B8iiXvVO2aoZH/lFFjak=";
      "scram-0.7.0" = "sha256-QTPxyXBpMXCDkRRJEMYly1GKp90khrwwuMI1eHc2H+Y=";
      "test-cert-gen-0.10.0-pre" = "sha256-Hyk4/iw6/SgEI70vPCNNbE9+nQ0pOAM158hncyUbvp8=";
      "test-utils-0.1.0" = "sha256-FoF/U89Q9E2Dlmpoh+cfDcScmhcsSNut+rE7BECJSJI=";
      "warp-0.3.6" = "sha256-knDt2aw/PJ0iabhKg+okwwnEzCY+vQVhE7HKCTM6QbE=";
    };
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    perl
  ];

  buildInputs =
    [ curl ]
    ++ lib.optionals stdenv.isDarwin [
      CoreServices
      Security
      libiconv
      xz
    ];

  checkFeatures = [ ];

  patches = [
    (substituteAll {
      src = ./0001-dynamically-patchelf-binaries.patch;
      inherit patchelf;
      dynamicLinker = stdenv.cc.bintools.dynamicLinker;
    })
  ];

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = edgedb;
    command = "edgedb --version";
  };

  meta = with lib; {
    description = "EdgeDB cli";
    homepage = "https://www.edgedb.com/docs/cli/index";
    license = with licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with maintainers; [
      ahirner
      kirillrdy
    ];
    mainProgram = "edgedb";
  };
}
