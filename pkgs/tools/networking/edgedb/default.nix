{ stdenv
, lib
, runCommand
, patchelf
, fetchFromGitHub
, rustPlatform
, makeWrapper
, pkg-config
, curl
, Security
, CoreServices
, libiconv
, xz
, perl
, substituteAll
}:

rustPlatform.buildRustPackage rec {
  pname = "edgedb";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev = "v${version}";
    sha256 = "sha256-vsPpWsOB3ewfT2gTX91OCh0bcSSuQ3wuSN7GZxARoF0=";
  };

  cargoSha256 = "sha256-S6/TAo5Q4TLMhl29yHuJMmSokVJJhKryMeLJF4pjiG8=";

  nativeBuildInputs = [ makeWrapper pkg-config perl ];

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

  meta = with lib; {
    description = "EdgeDB cli";
    homepage = "https://www.edgedb.com/docs/cli/index";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.ranfdev ];
  };
}
