{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.30";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "sad";
    rev = "refs/tags/v${version}";
    hash = "sha256-pTCdoKY/+ubUY3adN/Cqop0Gvuqh6Bs55arjT9mjQ18=";
  };

  cargoHash = "sha256-ndl0jFQA30h90nnEcIl2CXfF/+cuj/UqUV/7ilsUPb4=";

  nativeBuildInputs = [ python3 ];

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    changelog = "https://github.com/ms-jpq/sad/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sad";
  };
}
