{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, gettext
, pkg-config
, wrapGAppsHook
, sqlite
, libpinyin
, db
, ibus
, glib
, gtk3
, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-libpinyin";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    rev = version;
    sha256 = "sha256-fEEiwRoGGFAki1DMQvGuzjz2NAjhExyH11l8KTwjjsI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    ibus
    glib
    sqlite
    libpinyin
    (python3.withPackages (pypkgs: with pypkgs; [
      pygobject3
      (toPythonModule ibus)
    ]))
    gtk3
    db
  ];

  meta = with lib; {
    isIbusEngine = true;
    description = "IBus interface to the libpinyin input method";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}
