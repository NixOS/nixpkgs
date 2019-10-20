{ stdenv, fetchurl, SDL, zlib, libmpeg2, libmad, libogg, libvorbis, flac, alsaLib
, libGLSupported ? stdenv.lib.elem stdenv.hostPlatform.system stdenv.lib.platforms.mesaPlatforms
, openglSupport ? libGLSupported, libGLU_combined ? null
}:

assert openglSupport -> libGLU_combined != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.1.1";
  pname = "residualvm";

  src = fetchurl {
    url = "mirror://sourceforge/residualvm/residualvm-${version}-sources.tar.bz2";
    sha256 = "99c419b13885a49bdfc10a50a3a6000fd1ba9504f6aae04c74b840ec6f57a963";
  };

  buildInputs = [ stdenv SDL zlib libmpeg2 libmad libogg libvorbis flac alsaLib ]
    ++ optional openglSupport libGLU_combined;

  configureFlags = [ "--enable-all-engines" ];

  meta = {
    description = "Interpreter for LucasArts' Lua-based 3D adventure games";
    homepage = http://residualvm.org/;
    repositories.git = https://github.com/residualvm/residualvm.git;
    license = licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
