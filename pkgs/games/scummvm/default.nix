{ stdenv, fetchurl, SDL, zlib, libmpeg2, libmad, libogg, libvorbis, flac, alsaLib, mesa }:

stdenv.mkDerivation rec {
  name = "scummvm-1.9.0";

  src = fetchurl {
    url = "http://scummvm.org/frs/scummvm/1.9.0/scummvm-1.9.0.tar.bz2";
    sha256 = "813d7d8a76e3d05b45001d37451368711dadc32899ecf907df1cc7abfb1754d2";
  };
  
  buildInputs = [ SDL zlib libmpeg2 libmad libogg libvorbis flac alsaLib mesa ];

  hardeningDisable = [ "format" ];

  crossAttrs = {
    preConfigure = ''
      # Remove the --build flag set by the gcc cross wrapper setup
      # hook
      export configureFlags="--host=${stdenv.cross.config}"
    '';
    postConfigure = ''
      # They use 'install -s', that calls the native strip instead of the cross
      sed -i 's/-c -s/-c/' ports.mk;
    '';
  };

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
    platforms = stdenv.lib.platforms.linux;
  };
}

