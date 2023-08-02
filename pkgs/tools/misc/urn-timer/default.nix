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
  version = "unstable-2023-07-31";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "2dad51949aa21e0e66a3d34e916fb66689c6be2e";
    hash = "sha256-0pZjgKW4kyBgMGKEa8ZMhKtzbJX2MoXKID++iy16m2A=";
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
