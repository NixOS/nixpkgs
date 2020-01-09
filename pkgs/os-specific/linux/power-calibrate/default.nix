{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "power-calibrate";
  version = "0.01.29";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1v8wvhjqglkvk9cl2b48lkcwhbc6nsdi3hjd7sap4hyvd6703pgs";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];

  meta = with lib; {
    description = "Tool to calibrate power consumption";
    homepage = "https://kernel.ubuntu.com/~cking/power-calibrate/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
