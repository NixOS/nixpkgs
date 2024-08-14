{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hostname-debian";
  version = "3.23";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/h/hostname/hostname_${version}.tar.gz";
    sha256 = "sha256-vG0ZVLIoSYaf+LKmAuOfCLFwL2htS1jdeSfN61tIdu8=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace 'install -o root -g root' 'install'
  '';
  makeFlags = [ "BINDIR=$(out)/bin" "MANDIR=$(out)/share/man" ];

  meta = with lib; {
    description = "Utility to set/show the host name or domain name";
    longDescription = ''
      This package provides commands which can be used to display the system's
      DNS name, and to display or set its hostname or NIS domain name.
    '';
    homepage = "https://tracker.debian.org/pkg/hostname";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ posch ];
    platforms = platforms.gnu;
  };
}
