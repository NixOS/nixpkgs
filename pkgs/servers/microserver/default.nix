{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
   pname = "microserver";
   version = "0.2.0";

  src = fetchFromGitHub {
    owner = "robertohuertasm";
    repo = "microserver";
    rev = "v${version}";
    sha256 = "1bbbdajh74wh2fbidasim2mzmzqjrgi02v8b0g7vbhpdnlim6ixz";
  };

  cargoSha256 = "1hj2r3r84vjii0f67dplk2mhb1rgr56kdh0dmfyxrqbn7l6x9d87";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security ]);

  meta = with lib; {
    homepage = "https://github.com/robertohuertasm/microserver";
    description = "Simple ad-hoc server with SPA support";
    maintainers = with maintainers; [ flosse ];
    license = licenses.mit;
  };
}
