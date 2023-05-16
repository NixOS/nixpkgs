{ lib, stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
<<<<<<< HEAD
, gobject-introspection, procps }:
=======
, gobject-introspection }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "networkmanager_dmenu";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-RbJE6JCElctBY5HDJa6SIJhm8g9BugncLF5kmambPPc=";
  };

  nativeBuildInputs = [ gobject-introspection ];
  buildInputs = [ glib python pygobject3 networkmanager python3Packages.wrapPython procps ];
=======
    sha256 = "sha256-btwiKxmb1xDtPSTOIvpHJDQ5SY1gnBWlKnYOzzSLDEY=";
  };

  buildInputs = [ glib python pygobject3 gobject-introspection networkmanager python3Packages.wrapPython ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/doc/$pname
    cp networkmanager_dmenu $out/bin/
    cp networkmanager_dmenu.desktop $out/share/applications
    cp README.md $out/share/doc/$pname/
    cp config.ini.example $out/share/doc/$pname/
  '';

  postFixup = ''
    makeWrapperArgs="\
      --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH \
      --prefix PYTHONPATH : \"$(toPythonPath $out):$(toPythonPath ${pygobject3})\""
    wrapPythonPrograms
  '';


  meta = with lib; {
    description  = "Small script to manage NetworkManager connections with dmenu instead of nm-applet";
    homepage     = "https://github.com/firecat53/networkmanager-dmenu";
    license      = lib.licenses.mit;
    maintainers  = [ lib.maintainers.jensbin ];
    platforms    = lib.platforms.all;
  };
}
