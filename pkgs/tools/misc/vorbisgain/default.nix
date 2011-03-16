{ stdenv, fetchurl, unzip, libogg, libvorbis }:

stdenv.mkDerivation rec {
  name = "vorbisgain-0.34";

  src = fetchurl {
    url = "http://sjeng.org/ftp/vorbis/${name}.zip";
    sha256 = "1sjxl20ahhjv63b8a99sq9p14vz3lf1gacivkk0x2c11cc9zw4nr";
  };

  buildInputs = [ unzip libogg libvorbis ];
  patchPhase = ''
    chmod -v +x configure
    sed -e 's/^        /\t/' -i Makefile.*
    configureFlags="--mandir=$out/share/man"
    '';
}
