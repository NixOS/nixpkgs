{ stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
, gobjectIntrospection, dmenu }:

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  name = "networkmanager_dmenu-unstable-${version}";
  version = "2017-05-28";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = "eeb8e6922dee887890884f129b51bb21b0047d30";
    sha256 = "00n82sjjqk76sfxi92f5vnzpngk66cqwyzqdanbszpl019ajr5h6";
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
