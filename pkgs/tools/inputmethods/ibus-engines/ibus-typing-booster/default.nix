{ lib, stdenv, fetchFromGitHub, autoreconfHook, python3, ibus, pkg-config, gtk3, m17n_lib
, wrapGAppsHook, gobject-introspection
}:

let

  python = python3.withPackages (ps: with ps; [
    pygobject3
    dbus-python
  ]);

in

stdenv.mkDerivation rec {
  pname = "ibus-typing-booster";
  version = "2.22.4";

  src = fetchFromGitHub {
    owner = "mike-fabian";
    repo = "ibus-typing-booster";
    rev = version;
    hash = "sha256-AOCFdjQ5xz/B5Nx0+QVv5GdJyQEo0eH3in5Yaak9Sww=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config wrapGAppsHook gobject-introspection ];
  buildInputs = [ python ibus gtk3 m17n_lib ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${m17n_lib}/lib")
  '';

  meta = with lib; {
    homepage = "https://mike-fabian.github.io/ibus-typing-booster/";
    license = licenses.gpl3Plus;
    description = "A completion input method for faster typing";
    maintainers = with maintainers; [ ncfavier ];
    isIbusEngine = true;
  };
}
