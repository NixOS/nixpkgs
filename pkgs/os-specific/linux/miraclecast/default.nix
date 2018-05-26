{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, glib, readline, pcre, systemd, udev }:

stdenv.mkDerivation rec {
  name = "miraclecast-${version}";
  version = "1.0-20170427";

  src = fetchFromGitHub {
    owner  = "albfan";
    repo   = "miraclecast";
    rev    = "a395c3c7afc39a958ae8ab805dea0f5d22118f0c";
    sha256 = "03kbjajv2x0i2g68c5aij0icf9waxnqkc9pp32z60nc8zxy9jk1y";
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
