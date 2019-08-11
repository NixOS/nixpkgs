{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, glib, readline, pcre, systemd, udev }:

stdenv.mkDerivation rec {
  name = "miraclecast-${version}";
  version = "1.0-20190403";

  src = fetchFromGitHub {
    owner  = "albfan";
    repo   = "miraclecast";
    rev    = "960a785e10523cc525885380dd03aa2c5ba11bc7";
    sha256 = "05afqi33rv7k6pbkkw4mynj6p97vkzhhh13y5nh0yxkyhcgf45pm";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ glib pcre readline systemd udev ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Drely-udev=true"
    "-Dbuild-tests=true"
  ];

  meta = with stdenv.lib; {
    description = "Connect external monitors via Wi-Fi";
    homepage    = https://github.com/albfan/miraclecast;
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ tstrobel ];
    platforms   = platforms.linux;
  };
}
