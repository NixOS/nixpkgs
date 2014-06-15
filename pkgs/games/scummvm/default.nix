{ stdenv, fetchurl, SDL, zlib, libmpeg2, libmad, libogg, libvorbis, flac, alsaLib }:

stdenv.mkDerivation rec {
  name = "scummvm-1.6.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/scummvm/${name}.tar.bz2";
    sha256 = "1i3ywpq8csi58gdibdn51329vlj800l2laaw0lw18fcgdbd60q1r";
  };
  
  buildInputs = [ SDL zlib libmpeg2 libmad libogg libvorbis flac alsaLib ];

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
  };
}

