{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, udev, systemd, glib, readline }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "miraclecast-0.0-git-20151002";

  src = fetchFromGitHub {
    owner = "albfan";
    repo = "miraclecast";
    rev = "30b8c2d22391423f76ba582aaaa1e0936869103a";
    sha256 = "0i076n76kq64fayc7v06gr1853pk5r6ms86m57vd1xsjd0r9wyxd";
  };

  # INFO: It is important to list 'systemd' first as for now miraclecast
  # links against a customized systemd. Otherwise, a systemd package from
  # a propagatedBuildInput could take precedence.
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ systemd udev glib readline ];

  meta = {
    homepage = https://github.com/albfan/miraclecast;
    description = "Connect external monitors via Wi-Fi";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}
