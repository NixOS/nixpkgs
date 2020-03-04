{ stdenv
, fetchFromGitHub
, autoreconfHook
, gettext
, pkgconfig
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
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    rev = version;
    sha256 = "0b8rilk9zil9gvfhlk3rphcby6ph11dw66j175wp0na6h6hjlaf2";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkgconfig
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

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "IBus interface to the libpinyin input method";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}
