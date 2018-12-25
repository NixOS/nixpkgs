{ stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
, gobject-introspection }:

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  name = "networkmanager_dmenu-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = "v${version}";
    sha256 = "1z6151z7c4jv5k2i50zr7ld4k3m07dgpmss9f3hsav95cv55dcnb";
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


  meta = with stdenv.lib; {
    description  = "Small script to manage NetworkManager connections with dmenu instead of nm-applet";
    homepage     = https://github.com/firecat53/networkmanager-dmenu;
    license      = stdenv.lib.licenses.mit;
    maintainers  = [ stdenv.lib.maintainers.jensbin ];
    platforms    = stdenv.lib.platforms.all;
  };
}
