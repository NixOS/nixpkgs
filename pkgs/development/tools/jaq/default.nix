{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    sha256 = "sha256-Y1QLNiAeHKYsSbFW235mdTiHyQFBQQsO+FtuFxDX9Hs=";
  };

  cargoSha256 = "sha256-+9uy5R/dO2T/6dRhtYlPCKfosaYua0JvbECvMacc3XA=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
