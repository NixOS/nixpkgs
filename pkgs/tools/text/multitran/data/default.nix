{stdenv, fetchurl} :

# This package requires a locale ru_RU.cp1251 locale entry.
# Waiting for a better idea, I created it modifying a store file using:
#   localedef -f CP1251 -i ru_RU ru_RU.CP1251
# The store file mentioned is in "${glibc}/lib/locale/locale-archive"

stdenv.mkDerivation {
  name = "multitran-data-0.3";
  src = fetchurl {
      url = mirror://sourceforge/multitran/multitran-data.tar.bz2;
      sha256 = "9c2ff5027c2fe72b0cdf056311cd7543f447feb02b455982f20d4a3966b7828c";
  };

  patchPhase = ''
    sed -i -e 's@\$(DESTDIR)/usr@'$out'@' Makefile
  '';

  meta = {
    homepage = http://multitran.sourceforge.net/;
    description = "Multitran data english-russian";
    license = stdenv.lib.licenses.gpl2;
  };
}
