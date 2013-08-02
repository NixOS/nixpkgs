{ stdenv, fetchurl, pkgconfig, which
, SDL, mesa, alsaLib
}:

stdenv.mkDerivation rec {
  name = "retroarch-0.9.9";

  src = fetchurl {
    url = "http://themaister.net/retroarch-dl/${name}.tar.gz";
    sha256 = "08xlndpl14c4ccgp752ixx3a7ajf3xp93nawhinwxq0cw801prda";
  };

  buildInputs = [
    pkgconfig which SDL mesa alsaLib
  ];

  preConfigure = ''
    configureFlags="--global-config-dir=$out/etc"
  '';

  meta = {
    description = "A cross-platform multi-system emulator";
    homepage = "http://themaister.net/retroarch.html";
    license = stdenv.lib.licenses.gpl3Plus;
    platform = stdenv.lib.platforms.linux;
  };
}
