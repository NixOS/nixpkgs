{ stdenv, fetchFromGitHub, autoreconfHook, python3, ibus, pkgconfig, gtk3, m17n_lib
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
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "mike-fabian";
    repo = "ibus-typing-booster";
    rev = version;
    sha256 = "1k074y9439w8v6s71i7hhmkq9bgkl836y2a409rx3mb73vidadjr";
  };

  patches = [ ./hunspell-dirs.patch ];

  nativeBuildInputs = [ autoreconfHook pkgconfig wrapGAppsHook gobject-introspection ];
  buildInputs = [ python ibus gtk3 m17n_lib ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${m17n_lib}/lib")
  '';

  meta = with stdenv.lib; {
    homepage = https://mike-fabian.github.io/ibus-typing-booster/;
    license = licenses.gpl3Plus;
    description = "A typing booster engine for the IBus platform";
    maintainers = with maintainers; [ ma27 ];
    isIbusEngine = true;
  };
}
