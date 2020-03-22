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
  version = "1.11.92";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    rev = version;
    sha256 = "1day8adp37bwhmyhljfij2r48nv4if1brr4qvcwrkfa26n2kdayf";
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
