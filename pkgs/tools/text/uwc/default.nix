{ rustPlatform, lib, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "uwc";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "uwc";
    rev = "refs/tags/v${version}";
    hash = "sha256-Qv8vMjCMhpVxkJyH1uTsFXu2waO8oaLPuoBETaWOUqI=";
  };

  cargoHash = "sha256-20brxqYAvgBxbOQ7KOFviXxmFrSHDXNV/0lcks7x3a8=";

  doCheck = false;

  meta = with lib; {
    description = "Like wc, but unicode-aware, and with per-line mode";
    mainProgram = "uwc";
    homepage = "https://github.com/dead10ck/uwc";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
