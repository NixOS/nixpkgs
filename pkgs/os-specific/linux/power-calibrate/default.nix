{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "power-calibrate";
  version = "0.01.28";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1miyjs0vngzfdlsxhn5gndcalzkh28grg4m6faivvp1c6mjp794m";
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
