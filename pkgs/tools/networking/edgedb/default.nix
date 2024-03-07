{ stdenv
, lib
, patchelf
, fetchFromGitHub
, rustPlatform
, makeBinaryWrapper
, pkg-config
, curl
, Security
, CoreServices
, libiconv
, xz
, perl
, substituteAll
# for passthru.tests:
, edgedb
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "edgedb";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev = "v${version}";
    hash = "sha256-uilotat61U6jW1NLh7fVHOujkzUSFRdpeOx+ECGsByY=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "edgedb-derive-0.5.1" = "sha256-1tbWg3bLab3xlVQxb4G+kpXriO+zQpnrwAESy5Tqsu4=";
      "edgeql-parser-0.1.0" = "sha256-c5xBuW47xXgy8VLR/P7DvVhLBd0rvI6P9w82IPPsTwo=";
      "indexmap-2.0.0-pre" = "sha256-QMOmoUHE1F/sp+NeDpgRGqqacWLHWG02YgZc5vAdXZY=";
      "rexpect-0.5.0" = "sha256-vstAL/fJWWx7WbmRxNItKpzvgGF3SvJDs5isq9ym/OA=";
      "rustyline-8.0.0" = "sha256-CrICwQbHPzS4QdVIEHxt2euX+g+0pFYe84NfMp1daEc=";
      "serde_str-1.0.0" = "sha256-CMBh5lxdQb2085y0jc/DrV6B8iiXvVO2aoZH/lFFjak=";
    };
  };

  nativeBuildInputs = [ makeBinaryWrapper pkg-config perl ];

  buildInputs = [
    curl
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security libiconv xz ];

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
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ahirner kirillrdy ];
  };
}
