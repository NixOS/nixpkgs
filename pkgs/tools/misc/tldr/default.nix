{ lib, stdenv, fetchFromGitHub, curl, libzip, pkg-config, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "tldr";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-cpp-client";
    rev = "v${version}";
    sha256 = "sha256-xim5SB9/26FMjLqhiV+lj+Rm5Tk5luSIqwyYb3kXoFY=";
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
    homepage = "https://tldr-pages.github.io";
    changelog = "https://github.com/tldr-pages/tldr-c-client/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ taeer carlosdagos ];
    platforms = platforms.all;
  };
}
