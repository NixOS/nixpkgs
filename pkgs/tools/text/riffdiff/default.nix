{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.29.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-sKZ/VkE2eWmGYjnAxzElZkSQyXyZOzBO3B1lSDU1dO4=";
  };

  cargoHash = "sha256-8CQDlfJ698BOLQPuYjF0TpLjC93KvN9PvM3kexWnwVs=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
