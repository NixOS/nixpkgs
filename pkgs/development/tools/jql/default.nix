{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "7.1.12";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-k8BHmZe7cXUJV6OJlcFdabFiZwg4aEGnpyv5xeM3pH4=";
  };

  cargoHash = "sha256-G/t9R9WObZNj5AsF0rjNuTf10snIhJE/LFUvXk3KoBQ=";

  meta = with lib; {
    description = "JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
    mainProgram = "jql";
  };
}
