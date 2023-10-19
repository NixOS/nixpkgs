{ lib, stdenv
, fetchFromGitHub
, unstableGitUpdater
, xxd
, pkg-config
, imagemagick
, wrapGAppsHook
, gtk3
, jansson
}:

stdenv.mkDerivation {
  pname = "urn-timer";
  version = "unstable-2023-08-07";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "3468e297ee67aa83e6c26529acd35142ade5c6ff";
    hash = "sha256-e9u/bjFjwgF5QciiqB3AWhyYj7eCstzkpSR9+xNA+4I=";
  };

  nativeBuildInputs = [
    xxd
    pkg-config
    imagemagick
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    jansson
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/paoloose/urn.git";
  };

  meta = with lib; {
    homepage = "https://github.com/paoloose/urn";
    description = "Split tracker / timer for speedrunning with GTK+ frontend";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "urn-gtk";
  };
}
