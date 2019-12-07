{ stdenv
, fetchFromGitHub
, ninja
, meson
, pkgconfig
, gthree
, gsound
, epoxy
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "gnome-hexgl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "alexlarsson";
    repo = "gnome-hexgl";
    rev = version;
    sha256 = "08iy2iciscd2wbhh6v4cpghx8r94v1ffbgla9yb3bcsdhlag0iw4";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkgconfig
  ];

  buildInputs = [
    gthree
    gsound
    epoxy
    gtk3
  ];

  meta = with stdenv.lib; {
    description = "Gthree port of HexGL";
    homepage = "https://github.com/alexlarsson/gnome-hexgl";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
