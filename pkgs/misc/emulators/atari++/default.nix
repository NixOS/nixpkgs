{ stdenv, fetchurl, libSM, libX11, libICE, SDL, alsaLib, gcc-unwrapped, libXext }:

stdenv.mkDerivation rec {
  pname = "atari++";
  version = "1.83";

  src = fetchurl {
    url = "http://www.xl-project.com/download/${pname}_${version}.tar.gz";
    sha256 = "04fm2ic2qi4a52mi72wcaxyrpll4k8vvchx3qrik8rhg3jrxgm47";
  };

  buildInputs = [ libSM libX11 SDL libICE alsaLib gcc-unwrapped libXext ];

  postFixup = ''
    patchelf --set-rpath ${stdenv.lib.makeLibraryPath buildInputs} "$out/bin/atari++"
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.xl-project.com/";
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
