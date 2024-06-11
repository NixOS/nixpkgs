{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, webkitgtk
, wrapGAppsHook3
, glib-networking
, gobject-introspection
, openconnect
, pygobject3
, requests
}:
buildPythonPackage rec {
  pname = "gp-saml-gui";
  version = "0.1+20230507-${lib.strings.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = "gp-saml-gui";
    rev = "258f47cdc4a8ed57a1eef16667f6cad0d1cb49b1";
    sha256 = "sha256-g10S8C32mnOymCmGNdM8gmGpYn5/ObMJK3g6amKtQmI=";
  };

  buildInputs = lib.optional stdenv.isLinux glib-networking;

  nativeBuildInputs = [ wrapGAppsHook3 gobject-introspection glib-networking ];

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
    mainProgram = "gp-saml-gui";
    homepage = "https://github.com/dlenski/gp-saml-gui";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.pallix ];
  };
}
