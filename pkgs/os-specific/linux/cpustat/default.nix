{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "cpustat";
  version = "0.02.09";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "12xahv65yrhs5r830clkl1qnwg3dnrk5qn3zsznzbv1iy2f3cj7y";
  };

  buildInputs = [ ncurses ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];

  meta = with lib; {
    description = "CPU usage monitoring tool";
    homepage = "https://kernel.ubuntu.com/~cking/cpustat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
