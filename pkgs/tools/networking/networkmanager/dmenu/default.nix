{ lib, stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
, gobject-introspection }:

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "networkmanager_dmenu";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = "v${version}";
    sha256 = "sha256-RbJE6JCElctBY5HDJa6SIJhm8g9BugncLF5kmambPPc=";
  };

  nativeBuildInputs = [ gobject-introspection ];
  buildInputs = [ glib python pygobject3 networkmanager python3Packages.wrapPython ];

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
