{ stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
, gobject-introspection }:

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "networkmanager_dmenu";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = "${version}";
    sha256 = "1msk4zkm4042av61rgbwc62i62vnv9py93fm1bczmw0b1f54qpmk";
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
    homepage     = "https://github.com/firecat53/networkmanager-dmenu";
    license      = stdenv.lib.licenses.mit;
    maintainers  = [ stdenv.lib.maintainers.jensbin ];
    platforms    = stdenv.lib.platforms.all;
  };
}
