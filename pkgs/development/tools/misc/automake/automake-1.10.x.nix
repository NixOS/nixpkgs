{stdenv, fetchurl, perl, autoconf}:

stdenv.mkDerivation rec {
  name = "automake-1.10.1";

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.bz2";
    sha256 = "1v155av3vdsgj9fil66cw2g4vrqanvgn33kwv35xs3ibcyck8smj";
  };

  patches = [ ./test-broken-make.patch ];

  buildInputs = [perl autoconf];

  doCheck = true;

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;
  
  meta = {
    homepage = http://www.gnu.org/software/automake/;
    description = "GNU Automake, a GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = "GPLv2+";
  };
}
