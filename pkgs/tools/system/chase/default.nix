{ stdenv, fetchurl ,pkgconfig, libatomic_ops , boehmgc , ... }:

stdenv.mkDerivation rec {
  name = "chase_0.5.2.orig";

  buildInputs = [ pkgconfig libatomic_ops boehmgc ] ;
  src = fetchurl {
    url = "http://ftp.stw-bonn.de/debian/pool/main/c/chase/${name}.tar.gz";
    sha256 = "68d95c2d4dc45553b75790fcea4413b7204a2618dff148116ca9bdb0310d737f";
  };

  doCheck = true;
  makeFlags = [ "-e" ];
  makeFlagsArray="LIBS=-lgc";

  meta = {
    description = "Follow a symlink and print out its target file";
    longDescription = ''
      A commandline program that chases symbolic filesystems links to the original file
    '';
    homepage = "https://qa.debian.org/developer.php?login=rotty%40debian.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ "Maurizio Di Pietro" ];
    platforms = stdenv.lib.platforms.all;
  };
}
