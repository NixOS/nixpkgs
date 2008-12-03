{stdenv, fetchurl, perl, autoconf}:

stdenv.mkDerivation rec {
  name = "automake-1.10.2";

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.bz2";
    sha256 = "03v4gsvi71nhqvnxxbhkrksdg5icrn8yda021852njfragzck2n3";
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
