{ lib
, stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, pkg-config
, desktop-file-utils
, appstream
, python3
, shared-mime-info
, wrapGAppsHook
, gtk3
, pantheon
, libgee
}:

stdenv.mkDerivation rec {
  pname = "gnonograms";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "jeremypw";
    repo = "gnonograms";
    rev = "v${version}";
    sha256 = "1ly3inp6dvjrixdysz5hdfwlhbs49ks0lf8062z2iq6gaf8ivkb2";
  };

  postPatch = ''
    patchShebangs meson/post_install.py
  '';

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream
    python3
    shared-mime-info
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    pantheon.granite
    libgee
  ];

  meta = with lib; {
    description = "Nonograms puzzle game";
    longDescription = ''
      An implementation of the Japanese logic puzzle "Nonograms" written in
      Vala, allowing the user to:
      * Draw puzzles
      * Generate random puzzles of chosen difficulty
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/jeremypw/gnonograms";
    platforms = platforms.all;
  };
}
