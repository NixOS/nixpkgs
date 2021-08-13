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
  };
}
