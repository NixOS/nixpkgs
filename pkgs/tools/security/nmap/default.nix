{stdenv, fetchurl, libpcap, libX11, gtk, pkgconfig,
  openssl, python, pygtk}:
stdenv.mkDerivation {
  name = "Nmap";

  src = fetchurl {
    url = http://download.insecure.org/nmap/dist/nmap-4.60.tar.bz2;
    sha256 = "1jhway86lmrnyzvwi24ama1vrz89f9nmln29vr92kb31aw2nl30w";  };

  buildInputs = [libpcap libX11 gtk pkgconfig openssl python 
    pygtk];
}
