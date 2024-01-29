{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ia9N2jZlFW0Gu5YDfwh023zorMyWWL/KggeBRvCD1W4=";
  };

  cargoHash = "sha256-RHT6+zrY4SjoC/hgoMRal+cG8Ruip/6v7oVtKvR8doU=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "socks" ];

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };
}
