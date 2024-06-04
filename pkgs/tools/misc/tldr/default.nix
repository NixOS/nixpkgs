{ lib, stdenv, fetchFromGitHub, curl, libzip, pkg-config, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "tldr";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-c-client";
    rev = "v${version}";
    sha256 = "sha256-1L9frURnzfq0XvPBs8D+hBikybAw8qkb0DyZZtkZleY=";
  };

  buildInputs = [ curl libzip ];
  nativeBuildInputs = [ pkg-config installShellFiles ];

  makeFlags = ["CC=${stdenv.cc.targetPrefix}cc" "LD=${stdenv.cc.targetPrefix}cc" "CFLAGS="];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installShellCompletion --cmd tldr autocomplete/complete.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Simplified and community-driven man pages";
    longDescription = ''
      tldr pages gives common use cases for commands, so you don't need to hunt
      through a man page for the correct flags.
    '';
    homepage = "https://tldr.sh";
    changelog = "https://github.com/tldr-pages/tldr-c-client/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ taeer carlosdagos kbdharun];
    platforms = platforms.all;
    mainProgram = "tldr";
  };
}
