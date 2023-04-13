{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    sha256 = "sha256-v3dC5Qi0Op+oFCcbkbK1ZUQxWTEYVvXsc+ye9Kk9y7c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "regex-syntax-0.6.28" = "sha256-FltQ1TfA4XV+jC3dQZf7soTHc8R/nSwToPGcQUVwVYs=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
