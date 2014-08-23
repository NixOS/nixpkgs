{ stdenv, fetchurl }:

# this package is working only as root
# in order to work as a non privileged user you would need to suid the bin

stdenv.mkDerivation {
  name = "beep-1.3";
  src = fetchurl {
    url = http://www.johnath.com/beep/beep-1.3.tar.gz;
    md5 = "49c340ceb95dbda3f97b2daafac7892a";
  };

  makeFlags = "INSTALL_DIR=\${out}/bin/ MAN_DIR=\${out}/man/man1/";

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';
  meta = {
    description = "The advanced PC speaker beeper";
    homepage = http://www.johnath.com/beep/;
    license = stdenv.lib.licenses.gpl2;
  };
}
