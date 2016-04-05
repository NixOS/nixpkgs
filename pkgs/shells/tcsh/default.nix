{ stdenv, fetchurl
, ncurses }:

stdenv.mkDerivation rec {
  name = "tcsh-${version}";
  version = "6.19.00";
  
  src = fetchurl {
    urls = [ "ftp://ftp.funet.fi/pub/unix/shells/tcsh/${name}.tar.gz"
             "http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/${name}.tar.gz" ];
    sha256 = "0jaw51382pqyb6d1kgfg8ir0wd3p5qr2bmg8svcmjhlyp3h73qhj";
  };
  
  buildInputs = [ ncurses ];

  meta = with stdenv.lib;{
    description = "An enhanced version of the Berkeley UNIX C shell (csh)";
    longDescription = ''
      tcsh is an enhanced but completely compatible version of the
      Berkeley UNIX C shell, csh. It is a command language interpreter
      usable both as an interactive login shell and a shell script
      command processor.
      It includes:
      - command-line editor
      - programmable word completion
      - spelling correction
      - history mechanism
      - job control
    '';
    homepage = http://www.tcsh.org/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
