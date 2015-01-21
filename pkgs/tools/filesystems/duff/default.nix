{ stdenv, fetchurl, autoconf, automake, gettext }:

stdenv.mkDerivation rec {
  name = "duff-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/elmindreda/duff/archive/${version}.tar.gz";
    sha256 = "149dd80f9758085ed199c37aa32ad869409fa5e2c8da8a51294bd64ca886e058";
  };

  buildInputs = [ autoconf automake gettext ];

  preConfigure = ''
    # duff is currently badly packaged, requiring us to do extra work here that
    # should be done upstream. If that is ever fixed, this entire phase can be
    # removed along with all buildInputs.

    # gettexttize rightly refuses to run non-interactively:
    cp ${gettext}/bin/gettextize .
    substituteInPlace gettextize \
      --replace "read dummy" "echo '(Automatically acknowledged)' #"
    ./gettextize
    sed 's@po/Makefile.in\( .*\)po/Makefile.in@po/Makefile.in \1@' \
      -i configure.ac
    autoreconf -i
  '';

  meta = with stdenv.lib; {
    description = "Quickly find duplicate files.";
    homepage = http://duff.dreda.org/;
    license = with licenses; zlib;
    longDescription = ''
      Duff is a Unix command-line utility for quickly finding duplicates in
      a given set of files.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; all;
  };
}
