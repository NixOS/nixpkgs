{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, gcc
, libcxx
}:

rustPlatform.buildRustPackage rec {
  pname = "fh";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
    rev = "v${version}";
    hash = "sha256-9dWd0syDzoyjnhVoOCazRVA4pAAXud+cxggVlxXzJFg=";
  };

  cargoHash = "sha256-GzS/grxiMlrpJ2OG5BSne4RmSMUXXjKiwYyW4Aj69gc=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    gcc.cc.lib
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev libcxx}/include/c++/v1";
  };

  meta = with lib; {
    description = "The official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fh";
  };
}
