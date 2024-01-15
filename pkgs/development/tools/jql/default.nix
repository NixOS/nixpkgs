{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "7.1.2";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-gdHxaQkJJw/cvnWhAodp57VIfW5oehNE7/zGs7B5Akg=";
  };

  cargoHash = "sha256-urFwYHlHhxOmSBSpfEJV/3sg40r8CTnAOjjLqQ/GXeY=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
    mainProgram = "jql";
  };
}
