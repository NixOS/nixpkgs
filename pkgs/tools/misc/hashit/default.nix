{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, cmake, vala, python3, gnome3, gtk3, granite, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "hashit";
  version = "0.2.0";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = pname;
    rev = version;
    sha256 = "1d2g7cm7hhs354waidak9xkhhcvqlwnsl9d0bar9p82gfnpjdg7v";
  };

  nativeBuildInputs = [
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    granite
    gtk3
    gnome3.libgee
  ];

  meta = with stdenv.lib; {
    description = "A simple app for checking usual checksums";
    homepage    = https://github.com/artemanufrij/hashit;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
