{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "7.0.7";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-qqHErXJpW+G3nvZb8tRCB9ne+vt/5+bVArDa2purgEw=";
  };

  cargoHash = "sha256-Qmxob7YczhzFGRlB6dV58OXXhwhGXfrtBiCk+dm9iFE=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
    mainProgram = "jql";
  };
}
