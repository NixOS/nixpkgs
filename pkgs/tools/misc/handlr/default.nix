{ lib, stdenv, rustPlatform, fetchFromGitHub, shared-mime-info, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "handlr";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UYcJtBwbUDqDiRoj5PmO+urURfd7S7fSx2XhQRBrKTE=";
  };

  cargoSha256 = "sha256-xDQV8wVlzItz0lzR1nVRPVsg7nSf/khUhevDlGgSO3g=";

  nativeBuildInputs = [ installShellFiles shared-mime-info ];
  buildInputs = lib.optional stdenv.isDarwin libiconv;

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  postInstall = ''
    installShellCompletion \
      --zsh  completions/_handlr \
      --fish completions/handlr.fish
  '';

  meta = with lib; {
    description = "Alternative to xdg-open to manage default applications with ease";
    homepage = "https://github.com/chmln/handlr";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
