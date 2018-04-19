{ stdenv, fetchFromGitHub }:

# this package is working only as root
# in order to work as a non privileged user you would need to suid the bin

stdenv.mkDerivation {
  name = "beep-1.3";

  src = fetchFromGitHub {
    owner = "johnath";
    repo = "beep";
    rev = "0d790fa45777896749a885c3b93b2c1476d59f20";
    sha256 = "0dxz58an0sz5r82al5sc935y2z2k60rz12ikjvx7sz39rfirgfpc";
  };

  patches = [ ./cve-2018-0492.patch ];

  makeFlags = [
    "INSTALL_DIR=${placeholder "out"}/bin/"
    "MAN_DIR=${placeholder "out"}/man/man1/"
  ];

  preInstall = ''
    mkdir -p $out/{bin,man/man1}
  '';

  meta = with stdenv.lib; {
    description = "The advanced PC speaker beeper";
    homepage = http://www.johnath.com/beep/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
