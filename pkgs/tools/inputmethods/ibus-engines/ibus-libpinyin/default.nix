{ stdenv
, fetchFromGitHub
, autoreconfHook
, intltool
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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    rev = version;
    sha256 = "0zkzz6ig74nws8phqxbsggnpf5g5f2hxi0mdyn2m3s4nm14q3ma6";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
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

  postAutoreconf = ''
    intltoolize
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "IBus interface to the libpinyin input method";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}
