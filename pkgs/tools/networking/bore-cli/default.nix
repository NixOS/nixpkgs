{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    sha256 = "sha256-k1QpNpN6MVt7+PIDFcJtd7yD1ZpBJ9GFBBagVArRifs=";
  };

  cargoSha256 = "sha256-fNsMNU4npChqyIeonMSc6AjcBxVYVJhiG++HkQ3FM9M=";

  # tests do not find grcov path correctly
  meta = with lib; {
    description = "Rust tool to create TCP tunnels";
    homepage = "https://github.com/ekzhang/bore";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
  };
}
