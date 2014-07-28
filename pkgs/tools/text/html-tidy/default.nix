{ fetchcvs, stdenv, autoconf, automake, libtool }:

let date = "2009-07-04"; in
  stdenv.mkDerivation rec {
    name = "html-tidy-20090704";

    # According to http://tidy.sourceforge.net/, there are no new
    # release tarballs, so one has to either get the code from CVS or
    # use a decade-old tarball.

    src = fetchcvs {
      inherit date;
      cvsRoot = ":pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy";
      module = "tidy";
      sha256 = "d2e68b4335ebfde65ef66d5684f7693675c98bdd50b7a63c0b04f61db673aa6d";
    };

    buildInputs = [ autoconf automake libtool ];

    preConfigure = ''
      cp -rv build/gnuauto/* .
      AUTOMAKE="automake --foreign" autoreconf -vfi
    '';

    doCheck = true;

    meta = {
      description = "HTML Tidy, an HTML validator and `tidier'";

      longDescription = ''
        HTML Tidy is a command-line tool and C library that can be
        used to validate and fix HTML data.
      '';

      license = stdenv.lib.licenses.mit;

      homepage = http://tidy.sourceforge.net/;

      maintainers = [ ];
    };
  }
