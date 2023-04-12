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
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "09c075607a6e26307665b45095e133d6805f0aeb";
    hash = "sha256-0/V1KQxwHhpcruEsll0+JNtgT/6vEkpt+ff3SlsHYr8=";
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
