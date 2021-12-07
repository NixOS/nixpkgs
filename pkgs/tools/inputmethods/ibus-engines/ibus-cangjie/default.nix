{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, intltool
, pkg-config
, wrapGAppsHook
, ibus
, glib
, gobject-introspection
, gtk3
, python3 
}:

stdenv.mkDerivation rec {
  pname = "ibus-cangjie";
  version = "2.4_rev_${rev}";
  rev = "3cb2f401de8afa21fbe86250b62966686cbd8dbb";

  src = fetchFromGitHub {
    owner = "Cangjians";
    repo = "ibus-cangjie";
    rev = rev;
    sha256 = "sha256-ZnCg0FpvwNX1jNPYzVx6ZoiwEfwdyXUgmO/jL9qhN3s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    gobject-introspection
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [ 
    gtk3
    glib
    ibus 
    (python3.withPackages (pypkgs: with pypkgs; [ 
      pycangjie 
      pygobject3 
      (toPythonModule ibus)
    ]))
  ];

  meta = with lib; {
    isIbusEngine = true;
    description = "An IBus engine for the Cangjie and Quick input methods";
    license = licenses.gpl3Plus;
    # maintainers = with maintainers; [ michzappa ];
    platforms = platforms.linux;
  };
}
