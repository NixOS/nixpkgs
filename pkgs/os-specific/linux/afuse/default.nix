{ stdenv, fetchurl, pkgconfig, fuse }:

stdenv.mkDerivation {
  name = "afuse-0.2";

  src = fetchurl {
    url = mirror://sourceforge/afuse/0.2/afuse-0.2.tar.gz;
    sha256 = "1lj2jdks0bgwxbjqp5a9f7qdry19kar6pg7dh1ml98gapx9siylj";
  };

  buildInputs = [ pkgconfig fuse ];

  meta = { 
    description = "Automounter in userspace";
    homepage = http://sourceforge.net/projects/afuse;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
