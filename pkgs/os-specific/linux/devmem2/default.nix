{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "devmem2-2004-08-05";

  src = fetchurl {
    url = "http://lartmaker.nl/lartware/port/devmem2.c";
    sha256 = "14f1k7v6i1yaxg4xcaaf5i4aqn0yabba857zjnbg9wiymy82qf7c";
  };

  buildCommand = ''
    export hardeningDisable=format  # fix compile error
    cc "$src" -o devmem2
    install -D devmem2 "$out/bin/devmem2"
  '';

  meta = with stdenv.lib; {
    description = "Simple program to read/write from/to any location in memory";
    homepage = http://lartmaker.nl/lartware/port/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
