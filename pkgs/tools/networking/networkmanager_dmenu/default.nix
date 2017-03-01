{ stdenv, glib, fetchFromGitHub, networkmanager, python3Packages
, gobjectIntrospection, dmenu, makeWrapper }:

let inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  name = "networkmanager_dmenu-${version}";
  version = "git-20170301";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "networkmanager-dmenu";
    rev = "f631f34645cd581eb14cb2f3286fa02dcc60283f";
    sha256 = "0f3rkyhhyy3ab0bnaasazx33b952gfl3g3b3sg8fl00n90l53d11";
  };

  buildInputs = [ glib python pygobject3 makeWrapper gobjectIntrospection networkmanager ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp networkmanager_dmenu $out/bin/
    wrapProgram $out/bin/networkmanager_dmenu \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${pygobject3})"
  '';

  meta = with stdenv.lib; {
    description  = "Small script to manage NetworkManager connections with dmenu instead of nm-applet";
    homepage     = https://github.com/firecat53/networkmanager-dmenu;
    license      = stdenv.lib.licenses.mit;
    maintainers  = [ ];
    platforms    = stdenv.lib.platforms.all;
  };
}
