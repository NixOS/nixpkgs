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

  cargoHash = "sha256-N3zlaoBPVK4xI+t3F+NXz0DhqIOoE3lh3FftToACeZM=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
