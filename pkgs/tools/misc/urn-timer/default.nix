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
<<<<<<< HEAD
  version = "unstable-2023-08-07";
=======
  version = "unstable-2023-03-18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
<<<<<<< HEAD
    rev = "3468e297ee67aa83e6c26529acd35142ade5c6ff";
    hash = "sha256-e9u/bjFjwgF5QciiqB3AWhyYj7eCstzkpSR9+xNA+4I=";
  };

=======
    rev = "09c075607a6e26307665b45095e133d6805f0aeb";
    hash = "sha256-0/V1KQxwHhpcruEsll0+JNtgT/6vEkpt+ff3SlsHYr8=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace 'rsync -a --exclude=".*"' 'cp -r'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
