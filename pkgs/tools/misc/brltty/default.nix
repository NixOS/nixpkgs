{ stdenv, fetchurl, pkgconfig, alsaSupport, alsaLib ? null, bluez }:

assert alsaSupport -> alsaLib != null;

stdenv.mkDerivation rec {
  name = "brltty-5.2";
  
  src = fetchurl {
    url = "http://brltty.com/archive/${name}.tar.gz";
    sha256 = "1zaab5pxkqrv081n23p3am445d30gk0km4azqdirvcpw9z15q0cz";
  };
  
  buildInputs = [ pkgconfig alsaLib bluez ]
    ++ stdenv.lib.optional alsaSupport alsaLib;
  
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
  
  patchPhase = ''
    substituteInPlace configure --replace /sbin/ldconfig ldconfig
  '';
}
