{ stdenv, fetchurl ,pkgconfig, libatomic_ops , boehmgc }:

stdenv.mkDerivation rec {
  name = "chase-0.5.2";

  buildInputs = [ pkgconfig libatomic_ops boehmgc ] ;
  src = fetchurl {
    url = "mirror://debian/pool/main/c/chase/${name}.orig.tar.gz";
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
    maintainers = [ stdenv.lib.maintainers.polyrod ];
    platforms = stdenv.lib.platforms.all;
  };
}
