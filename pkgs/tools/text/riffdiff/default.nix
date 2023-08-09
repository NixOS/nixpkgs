{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.23.4";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-NyVtGj4ZE/DdGWKt+v4LXAhf7ZK+JHjmLnViPypgmA4=";
  };

  cargoHash = "sha256-qsUFt+w9CEZdqzjf0EiB/Kkx2evHwOycrE8MYdrCHuo=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
