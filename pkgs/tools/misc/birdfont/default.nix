{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  xmlbird,
  cairo,
  gdk-pixbuf,
  libgee,
  glib,
  gtk3,
  webkitgtk_4_0,
  libnotify,
  sqlite,
  vala,
  gobject-introspection,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.33.3";

  src = fetchurl {
    url = "https://birdfont.org/releases/birdfont-${version}.tar.xz";
    sha256 = "sha256-NNw7203BtHhNyyQezb3/EP98cTsu7ABDFBnM5Ms2ePY=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
    vala
    gobject-introspection
    wrapGAppsHook3
    autoPatchelfHook
  ];
  buildInputs = [
    xmlbird
    libgee
    cairo
    gdk-pixbuf
    glib
    gtk3
    webkitgtk_4_0
    libnotify
    sqlite
    gsettings-desktop-schemas
  ];

  postPatch = ''
    substituteInPlace install.py \
      --replace 'platform.version()' '"Nix"'

    patchShebangs .
  '';

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = with lib; {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = "https://birdfont.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
