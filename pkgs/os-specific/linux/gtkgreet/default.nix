{ stdenv
, lib
, fetchFromSourcehut
, pkg-config
, cmake
, meson
, ninja
, gtk3
, gtk-layer-shell
, json_c
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "gtkgreet";
  version = "0.7";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "ms+2FdtzzNlmlzNxFhu4cpX5H+5H+9ZOtZ0p8uVA3lo=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    json_c
    scdoc
  ];

  mesonFlags = [
    "-Dlayershell=enabled"
  ];

  meta = with lib; {
    description = "GTK based greeter for greetd, to be run under cage or similar";
    homepage = "https://git.sr.ht/~kennylevinsen/gtkgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
