{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.15";

  src = fetchurl {
    url = "https://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ClVFqq22QBQsH4iNNmp43fhyR5mWf6IGhqcAU71iF1E=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with lib; {
    homepage = "https://ipset.netfilter.org/";
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
    longDescription = ''
      IP sets are a framework inside the Linux 2.4.x and later kernel,
      which can be administered by the ipset utility.
      Depending on the type, currently an IP set may store IP addresses,
      (TCP/UDP) port numbers or IP addresses with MAC addresses in a way,
      which ensures lightning speed when matching an entry against a set.
    '';
  };
}
