{ lib, stdenv
, fetchFromGitHub
, ninja
, meson
, pkg-config
, gthree
, gsound
, libepoxy
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "gnome-hexgl";
  version = "unstable-2020-07-24";

  src = fetchFromGitHub {
    owner = "alexlarsson";
    repo = "gnome-hexgl";
    rev = "f47a351055a235730795341dcd6b2397cc4bfa0c";
    sha256 = "yZWGymaSUfnCP8VAEdDH64w0muSnRK/XPi1/IqTrE4k=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
  ];

  buildInputs = [
    gthree
    gsound
    libepoxy
    gtk3
  ];

  meta = with lib; {
    description = "Gthree port of HexGL";
    mainProgram = "gnome-hexgl";
    homepage = "https://github.com/alexlarsson/gnome-hexgl";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
