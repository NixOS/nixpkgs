{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lout-3.36";
  src = fetchurl {
    url = ftp://ftp.cs.usyd.edu.au/jeff/lout/lout-3.36.tar.gz;
    sha256 = "b689cbe12074be8817c90070b162593fc9cc51f2f8868701833ff599b24fd4ad";
  };

  builder = ./builder.sh;

  meta = {
    description = ''Lout is a document layout system, similar in functionality
    		    to TeX/LaTeX, but based on a purely functional programming
		    language.  It can produce PostScript output.'';
    homepage = http://www.cs.usyd.edu.au/~jeff/;
    license = "GPL";
  };
}
