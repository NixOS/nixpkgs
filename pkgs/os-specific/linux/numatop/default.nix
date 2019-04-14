{ stdenv, fetchurl, pkgconfig, numactl, ncurses, check }:

stdenv.mkDerivation rec {
  pname = "numatop";
  version = "2.1";
  src = fetchurl {
    url = "https://github.com/intel/${pname}/releases/download/v${version}/${pname}-v${version}.tar.xz";
    sha256 = "1s7psq1xyswj0lpx10zg5lnppav2xy9safkfx3rssrs9c2fp5d76";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ numactl ncurses ];
  checkInputs = [ check ];

  doCheck  = true;

  meta = with stdenv.lib; {
    description = "observation tool for runtime memory locality characterization and analysis of processes and threads running on a NUMA system";
    homepage = https://01.org/numatop;
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = stdenv.lib.platforms.all;
  };
}
