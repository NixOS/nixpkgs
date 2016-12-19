{ stdenv, fetchurl, unzip, libogg, libvorbis }:

stdenv.mkDerivation rec {
  name = "vorbisgain-0.37";

  src = fetchurl {
    url = "http://sjeng.org/ftp/vorbis/${name}.tar.gz";
    sha256 = "1v1h6mhnckmvvn7345hzi9abn5z282g4lyyl4nnbqwnrr98v0vfx";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ unzip libogg libvorbis ];

  patchPhase = ''
    chmod -v +x configure
    configureFlags="--mandir=$out/share/man"
  '';

  meta = with stdenv.lib; {
    homepage = http://sjeng.org/vorbisgain.html;
    description = "A utility that corrects the volume of an Ogg Vorbis file to a predefined standardized loudness";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
