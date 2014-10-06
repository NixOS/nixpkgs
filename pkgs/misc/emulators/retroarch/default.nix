{ stdenv, fetchgit, pkgconfig, which
, SDL, mesa, alsaLib
, libXxf86vm, libXinerama, libXv
}:

stdenv.mkDerivation rec {
  name = "retroarch-bare-0.9.9.7";

  src = fetchgit {
    url = "https://github.com/libretro/RetroArch.git";
    rev = "ea0c4880556e0f9d1fe8253ddc713bc743b00e1b";
    sha256 = "1jhyh7f8ijy67fxslxqsp8pjl2lwayjljp06hp4n5cn33yajpbd7";
  };

  buildInputs = [
    pkgconfig which SDL mesa alsaLib
    libXxf86vm libXinerama libXv
  ];

  preConfigure = ''
    configureFlags="--global-config-dir=$out/etc"
  '';

  meta = {
    description = "Modular multi-system game/emulator system";
    homepage = "http://www.libretro.com/";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };
}
