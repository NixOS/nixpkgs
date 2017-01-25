{ stdenv, fetchurl, pkgconfig, alsaSupport, alsaLib ? null, bluez, systemdSupport, systemd ? null }:

assert alsaSupport -> alsaLib != null;
assert systemdSupport -> systemd != null;

stdenv.mkDerivation rec {
  name = "brltty-5.4";
  
  src = fetchurl {
    url = "http://brltty.com/archive/${name}.tar.gz";
    sha256 = "1993brxa76yf7z3ckax0bbmqv6jp8vjwxp19h425v4gpm0m17k7l";
  };

  patches = [ ./systemd.patch ];
  
  buildInputs = [ pkgconfig bluez ]
    ++ stdenv.lib.optional alsaSupport alsaLib
    ++ stdenv.lib.optional systemdSupport systemd;
  
  meta = {
    description = "Access software for a blind person using a braille display";
    longDescription = ''
      BRLTTY is a background process (daemon) which provides access to the Linux/Unix
      console (when in text mode) for a blind person using a refreshable braille display.
      It drives the braille display, and provides complete screen review functionality.
      Some speech capability has also been incorporated. 
    '';
    homepage = http://www.brltty.com/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bramd ];
    platforms = stdenv.lib.platforms.all;
  };
  
  preConfigurePhases = [ "preConfigure" ];

  preConfigure = ''
    substituteInPlace configure --replace /sbin/ldconfig ldconfig
  '';
}
