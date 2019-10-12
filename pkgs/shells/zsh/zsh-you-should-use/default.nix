{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-you-should-use";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = pname;
    rev = version;
    sha256 = "1n0mcgahx40acqjj617k0rhqpzjqjaa9xfs4b1xrjp3qdy9s0ns0";
  };

  dontBuild = true;

  installPhase = ''
    install -D you-should-use.plugin.zsh $out/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/MichaelAquilina/zsh-you-should-use;
    license = licenses.gpl3;
    description = "ZSH plugin that reminds you to use existing aliases for commands you just typed";
    maintainers = with maintainers; [ ma27 ];
  };
}
