{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.29";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "sad";
    rev = "refs/tags/v${version}";
    hash = "sha256-TLVUvz/phAy+ljIsdv4GVSFHTAZ5ywQs32WHsu9g9Fc=";
  };

  cargoHash = "sha256-4XmTxeKbdC4HRownFlEc4GrSVimKkQg/yNI0us7gzQI=";

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
