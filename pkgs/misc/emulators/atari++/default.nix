{ stdenv, fetchurl, libSM, libX11, SDL }:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "atari++-${version}";
  version = "1.73";

  src = fetchurl {
    url = "http://www.xl-project.com/download/atari++_${version}.tar.gz";
    sha256 = "1y5kwh08717jsa5agxrvxnggnwxq36irrid9rzfhca1nnvp9a45l";
  };

  buildInputs = [ libSM libX11 SDL ];

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
