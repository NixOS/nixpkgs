{stdenv, fetchurl, libpcap, libX11, gtk, pkgconfig}:
stdenv.mkDerivation {
  name = "Nmap";

  src = fetchurl {
    url = http://insecure.org/nmap/dist/nmap-4.21ALPHA4.tar.bz2;
    md5 = "eae883e12f3640f7c52d66e0844d0ab1";
  };

  buildInputs = [libpcap libX11 gtk pkgconfig];
}
