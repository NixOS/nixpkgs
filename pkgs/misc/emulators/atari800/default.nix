{ stdenv, fetchurl
, unzip, zlib, SDL, readline, libGLU, libGL, libX11 }:

with stdenv.lib;
stdenv.mkDerivation rec{
  pname = "atari800";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/atari800/atari800/${version}/${pname}-${version}.tar.gz";
    sha256 = "1dcynsf8i52y7zyg62bkbhl3rdd22ss95zs2s9jm4y5jvn4vks88";
  };

  buildInputs = [ unzip zlib SDL readline libGLU libGL libX11 ];

  configureFlags = [
    "--target=default"
    "--with-video=sdl"
    "--with-sound=sdl"
    "--with-readline"
    "--with-opengl"
    "--with-x"
    "--enable-riodevice"
  ];

  preConfigure = "cd src";

  meta = {
    homepage = http://atari800.sourceforge.net/;
    description = "An Atari 8-bit emulator";
    longDescription = ''
      Atari800 is the emulator of Atari 8-bit computer systems and
      5200 game console for Unix, Linux, Amiga, MS-DOS, Atari
      TT/Falcon, MS-Windows, MS WinCE, Sega Dreamcast, Android and
      other systems supported by the SDL library.
    '';
    maintainers = [ maintainers.AndersonTorres ];
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
