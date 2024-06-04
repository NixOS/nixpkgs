{ lib, stdenv
, fetchFromGitHub
, unstableGitUpdater
, xxd
, pkg-config
, imagemagick
, wrapGAppsHook3
, gtk3
, jansson
, nixosTests
}:

stdenv.mkDerivation {
  pname = "urn-timer";
  version = "0-unstable-2024-03-05";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "10082428749fabb69db1556f19940d8700ce48a2";
    hash = "sha256-sQjHQ/i1d4v4ZnM0YAay+MdIj5l/FfIYj+NdH48OqfU=";
  };

  nativeBuildInputs = [
    xxd
    pkg-config
    imagemagick
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    jansson
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/paoloose/urn.git";
  };

  passthru.tests.nixosTest = nixosTests.urn-timer;

  meta = with lib; {
    homepage = "https://github.com/paoloose/urn";
    description = "Split tracker / timer for speedrunning with GTK+ frontend";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "urn-gtk";
  };
}
