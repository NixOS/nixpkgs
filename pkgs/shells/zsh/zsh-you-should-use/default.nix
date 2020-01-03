{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-you-should-use";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = pname;
    rev = version;
    sha256 = "1xzq7xmmx4rg53pd69d0s9n561q4z35hlbb2sq2xd76gk3x6fars";
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
