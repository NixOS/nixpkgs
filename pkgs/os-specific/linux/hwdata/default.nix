{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.300";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/hwdata/v0.300.tar.gz/sha512/34294fcf65c3cb17c19d625732d1656ec1992dde254a68ee35681ad2f310bc05028a85889efa2c1d1e8a2d10885ccc00185475a00f6f2fb82d07e2349e604a51/v0.300.tar.gz";
    sha256 = "03xlj05qyixhnsybq1qnr7j5q2nvirs4jxpgg4sbw8swsqj3dgqi";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = "--datadir=$(prefix)/data";

  meta = {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
