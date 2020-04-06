{ stdenv, fetchurl, libSM, libX11, libICE, SDL, alsaLib, gcc-unwrapped, libXext }:

with stdenv.lib;
stdenv.mkDerivation rec{
  pname = "atari++";
  version = "1.81";

  src = fetchurl {
    url = "http://www.xl-project.com/download/atari++_${version}.tar.gz";
    sha256 = "1sv268dsjddirhx47zaqgqiahy6zjxj7xaiiksd1gjvs4lvf3cdg";
  };

  buildInputs = [ libSM libX11 SDL libICE alsaLib gcc-unwrapped libXext ];

  postFixup = ''
    patchelf --set-rpath ${stdenv.lib.makeLibraryPath buildInputs} "$out/bin/atari++"
  '';

  meta = {
    homepage = http://www.xl-project.com/;
    description = "An enhanced, cycle-accurated Atari emulator";
    longDescription = ''
      The Atari++ Emulator is a Unix based emulator of the Atari eight
      bit computers, namely the Atari 400 and 800, the Atari 400XL,
      800XL and 130XE, and the Atari 5200 game console. The emulator
      is auto-configurable and will compile on a variety of systems
      (Linux, Solaris, Irix).
    '';
    maintainers = [ maintainers.AndersonTorres ];
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
