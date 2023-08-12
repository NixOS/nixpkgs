{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, webkitgtk
, wrapGAppsHook
, glib-networking
, gobject-introspection
, openconnect
, pygobject3
, requests
}:
buildPythonPackage rec {
  pname = "gp-saml-gui";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = "gp-saml-gui";
    rev = "085d3276e17e1094e22e5d49545e273147598eb4";
    sha256 = "sha256-5vIfgDaHE3T+euLliEyXe+Xikf5VyW3b9C2GapWx278=";
  };

  buildInputs = lib.optional stdenv.isLinux glib-networking;

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection glib-networking ];

  propagatedBuildInputs = [
    requests
    pygobject3
    openconnect
  ] ++ lib.optional stdenv.isLinux webkitgtk;

  preFixup = ''
    gappsWrapperArgs+=(
      --set WEBKIT_DISABLE_COMPOSITING_MODE "1"
    )
  '';

  meta = with lib; {
    description = "Interactively authenticate to GlobalProtect VPNs that require SAML";
    homepage = "https://github.com/dlenski/gp-saml-gui";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.pallix ];
  };
}
