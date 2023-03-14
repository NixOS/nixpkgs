{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G5dEN1yO/WnMLVZtxL6vD+YjvHDWiWehZSqeL43IDXE=";
  };

  cargoSha256 = "sha256-carsp6IRFCw5bLRYoyy6QP8jnImTSf/6GxYDH9lR7GA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completions/argc.{bash,zsh}
  '';

  meta = with lib; {
    description = "A tool to handle sh/bash cli parameters";
    homepage = "https://github.com/sigoden/argc";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
