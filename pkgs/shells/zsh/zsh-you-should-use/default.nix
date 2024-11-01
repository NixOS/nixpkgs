{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-you-should-use";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = pname;
    rev = version;
    sha256 = "sha256-+3iAmWXSsc4OhFZqAMTwOL7AAHBp5ZtGGtvqCnEOYc0=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    install -D you-should-use.plugin.zsh $out/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/MichaelAquilina/zsh-you-should-use";
    license = licenses.gpl3;
    description = "ZSH plugin that reminds you to use existing aliases for commands you just typed";
    maintainers = [ ];
  };
}
