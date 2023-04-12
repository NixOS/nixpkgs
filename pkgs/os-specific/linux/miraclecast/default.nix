{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config
, glib, readline, pcre, systemd, udev }:

stdenv.mkDerivation {
  pname = "miraclecast";
  version = "1.0-20190403";

  src = fetchFromGitHub {
    owner  = "albfan";
    repo   = "miraclecast";
    rev    = "960a785e10523cc525885380dd03aa2c5ba11bc7";
    sha256 = "05afqi33rv7k6pbkkw4mynj6p97vkzhhh13y5nh0yxkyhcgf45pm";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ glib pcre readline systemd udev ];

  mesonFlags = [
    "-Drely-udev=true"
    "-Dbuild-tests=true"
  ];

  meta = with lib; {
    description = "Connect external monitors via Wi-Fi";
    homepage    = "https://github.com/albfan/miraclecast";
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms   = platforms.linux;
  };
}
