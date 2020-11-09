{ lib, python3Packages, fetchFromGitHub, gtk3, gobject-introspection, webkitgtk,
  wrapGAppsHook, glib-networking }:

python3Packages.buildPythonApplication rec {
  pname = "gp-saml-gui";
  version = "c557c32ce9429fec2d7054f63195b30b97cba47d";

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = pname;
    rev = version;
    sha256 = "1yaqd8rf9lhahhdycpdrih70imp771b0ihs66clc7j7c3nxr8lym";
  };

  nativeBuildInputs = [ wrapGAppsHook webkitgtk gobject-introspection ];
  buildInputs = [
    gtk3 glib-networking
  ];

  propagatedBuildInputs = with python3Packages; [ requests pygobject3 ];

  meta = with lib; {
    description = "A tool to authenticate to GlobalProtect VPN which uses SAML for authentication";
    license = licenses.gpl3Only;
    homepage = "https://github.com/dlenski/gp-saml-gui";
  };
}
