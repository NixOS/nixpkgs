{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "tcsh-6.18.01";
  
  src = fetchurl {
    url = "ftp://ftp.funet.fi/pub/unix/shells/tcsh/${name}.tar.gz";
    sha256 = "1a4z9kwgx1iqqzvv64si34m60gj34p7lp6rrcrb59s7ka5wa476q";
  };
  
  buildInputs = [ncurses];

  postInstall =
    ''
      ln -s tcsh $out/bin/csh
    '';

  meta = {
    homepage = http://www.tcsh.org/;
    description = "An enhanced version of the Berkeley UNIX C shell (csh)";
  };

  passthru = {
    shellPath = "/bin/tcsh";
  };
}
