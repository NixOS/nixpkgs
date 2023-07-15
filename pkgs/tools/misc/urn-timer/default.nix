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
  version = "unstable-2023-07-01";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "8efdabcdd806b3b8997b82925d26209e6da8311b";
    hash = "sha256-lQVdHD3IkITJ2P2zimhFLTxmOzZkdWOg/RhR2xlBLJU=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace 'rsync -a --exclude=".*"' 'cp -r'
  '';

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
