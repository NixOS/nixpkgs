{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gFPN3aSukh0QMfGLn65icf5ZyYb8Y+r+GMdG2gm2InY=";
  };

  cargoHash = "sha256-XJW0TDRJdLwgWDm5ZBSCUj5VS5ZowGCr6tHV0MpZuvI=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
