{ stdenv, fetchurl, which, pkgconfig
, SDL, openal, libXv, mesa
}:

stdenv.mkDerivation rec {
  name = "retroarch-0.9.7";

  src = fetchurl {
    url = "http://themaister.net/retroarch-dl/${name}.tar.gz";
    sha256 = "1xknz9m3s94m7g645jmszn0x3ihsljk57mk672l60mkplsnxkdvm";
  };

  preInstall = ''
    sed -i 's:$(DESTDIR)/etc:$(PREFIX)/etc:g' Makefile
  '';

  buildInputs = [
    libXv mesa SDL openal which pkgconfig
  ];

  meta = {
    description = "A multi-system emulator for Linux, Windows, Mac OS X and *BSD";
    license = "GPLv3+";
  };
}
