{ lib, stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  pname = "tcpdump";
  version = "4.99.0";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "0hmqh2fx8rgs9v1mk3vpywj61xvkifz260q685xllxr8jmxg3wlc";
  };

  postPatch = ''
    patchShebangs tests
  '';

  checkInputs = [ perl ];

  buildInputs = [ libpcap ];

  configureFlags = lib.optional
    (stdenv.hostPlatform != stdenv.buildPlatform)
    "ac_cv_linux_vers=2";

  meta = with lib; {
    description = "Network sniffer";
    homepage = "https://www.tcpdump.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.unix;
  };
}
