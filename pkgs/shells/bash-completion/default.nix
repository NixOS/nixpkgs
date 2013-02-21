{ stdenv, fetchgit, autoconf, automake }:

stdenv.mkDerivation {
  name = "bash-completion-2.0-95-gd08b9f2";

  src = fetchgit {
    url = "http://anonscm.debian.org/git/bash-completion/bash-completion.git";
    rev = "d08b9f233559b3dced20050ba312b08fe0de53b4";
    sha256 = "0jybaib2bmpk5qd80y1l6wmfcd0b95cmf1l3hcb0ckpj0pjff0bn";
  };

  buildInputs = [ autoconf automake ];

  preConfigure = "autoreconf -i";

  doCheck = true;

  meta = {
    homepage = "http://bash-completion.alioth.debian.org/";
    description = "Programmable completion for the bash shell";
    license = "GPL";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
