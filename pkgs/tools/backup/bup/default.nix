{ stdenv, fetchurl, python, unzip, perl }:

stdenv.mkDerivation {
  name = "bup-0.24b";
  src = fetchurl {
    url = "https://github.com/apenwarr/bup/zipball/bup-0.24b";
    sha256 = "0l50i8mrg43ahd8fn1n6pwa0xslxr07pvkh0r4qyywv55172ip8v";
    name = "bup-0.24b.zip";
  };
  buildInputs = [ unzip python perl ];
  patchPhase = ''
    for f in cmd/* lib/tornado/* lib/tornado/test/* t/* wvtest.py main.py; do
      substituteInPlace $f --replace "/usr/bin/env python" "${python}/bin/python"
    done
    substituteInPlace Makefile --replace "./format-subst.pl" "perl ./format-subst.pl"
    substituteInPlace lib/bup/csetup.py --replace "'bupsplit.c'])" "'bupsplit.c'], library_dirs=['${python}/lib'])"
  '';
  makeFlags = "MANDIR=$(out)/man DOCDIR=$(out)/share/doc/bup BINDIR=$(out)/bin LIBDIR=$(out)/lib/bup";
  meta = {
    description = "Highly efficient file backup system based on the git packfile format. Capable of doing *fast* incremental backups of virtual machine images.";
    homepage = "https://github.com/apenwarr/bup";
  };
}
