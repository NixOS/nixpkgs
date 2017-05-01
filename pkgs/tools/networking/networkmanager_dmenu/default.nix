{ stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
, gobjectIntrospection, dmenu }:

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  name = "networkmanager_dmenu-unstable-${version}";
  version = "2017-04-13";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = "fbc0704702b32c2efb30ba6b5c0ad6f054a71a18";
    sha256 = "1584zrhla1njvkrbvb1rq66q06gs510f0l1ls3z7x7jmn322y6yr";
  };

  buildInputs = [ glib python pygobject3 gobjectIntrospection networkmanager python3Packages.wrapPython ];

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
