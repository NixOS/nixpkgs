{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  xmlbird,
  cairo,
  gdk-pixbuf,
  libgee,
  glib,
  gtk3,
  webkitgtk_4_1,
  libnotify,
  sqlite,
  vala,
  gobject-introspection,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  autoPatchelfHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "birdfont";
  version = "2.33.6";

  src = fetchFromGitHub {
    owner = "johanmattssonm";
    repo = "birdfont";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-7xVjY/yH7pMlUBpQc5Gb4t4My24Mx5KkARVp2KSr+Iw=";
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
    webkitgtk_4_1
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = "https://birdfont.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
})
