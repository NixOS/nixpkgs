{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rJTECX6JgIoOFpUWK4jYF6duGfhFn6SCNsHzotq5Fhg=";
  };

  cargoHash = "sha256-XVXHVkwkVYaETN4NAcZkoSQJJK3FxuD4uk7hll47pLM=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
