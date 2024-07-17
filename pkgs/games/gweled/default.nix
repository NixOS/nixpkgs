{
  lib,
  stdenv,
  fetchbzr,
  gettext,
  gtk2,
  wrapGAppsHook3,
  autoreconfHook,
  pkg-config,
  libmikmod,
  librsvg,
  libcanberra-gtk2,
  hicolor-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "gweled";
  version = "unstable-2021-02-11";

  src = fetchbzr {
    url = "lp:gweled";
    rev = "108";
    sha256 = "sha256-rM4dgbYfSrVqZwi+xzKuEtmtjK3HVvqeutmni1vleLo=";
  };

  doCheck = false;

  postPatch = ''
    substituteInPlace configure.ac --replace "AM_GNU_GETTEXT_VERSION([0.19.8])" "AM_GNU_GETTEXT_VERSION([${gettext.version}])"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gettext
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gtk2
    libmikmod
    librsvg
    hicolor-icon-theme
    libcanberra-gtk2
  ];

  configureFlags = [ "--disable-setgid" ];

  meta = with lib; {
    description = "Bejeweled clone game";
    mainProgram = "gweled";
    homepage = "https://gweled.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
