{ lib, stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
, gobject-introspection }:

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "networkmanager_dmenu";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = version;
    sha256 = "1liidqh8c33pxyb07qyj0jkd0fdak73g9r2iwiq62vfzrpik09k0";
  };

  buildInputs = [ glib python pygobject3 gobject-introspection networkmanager python3Packages.wrapPython ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp networkmanager_dmenu $out/bin/
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
