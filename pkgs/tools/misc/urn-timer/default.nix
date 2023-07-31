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
  version = "unstable-2023-07-28";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "70cc5bf6bc57593226a1648f9dd64353384dee87";
    hash = "sha256-acWcGBqwBVOcdy8N++1xVMjfWjTN6Ev3bRGj4BDos0E=";
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
