{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "7.1.8";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
    hash = "sha256-TjpbFX7k4coZH8IY4bygLwj8Z4JLQQ9yUqOmmr7NU9s=";
  };

  cargoHash = "sha256-7mzmaXeYZGtUjefC7Zo8wOArBuus7mfu6AaKE4tS5HE=";

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      akshgpt7
      figsoda
    ];
    mainProgram = "jql";
  };
}
