<<<<<<< HEAD
{ lib
, stdenv
, buildPackages
, docbook_xsl
, fetchFromGitHub
, glib
, gobject-introspection
, gtk-doc
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, withDocs ? stdenv.hostPlatform.emulatorAvailable buildPackages
}:
=======
{ lib, stdenv, meson, ninja, fetchFromGitHub, glib, pkg-config, gtk-doc, docbook_xsl, gobject-introspection }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "playerctl";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "sha256-OiGKUnsKX0ihDRceZoNkcZcEAnz17h2j2QUOSVcxQEY=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    docbook_xsl
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
  ] ++ lib.optionals (withDocs && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];
  buildInputs = [ glib ];

  mesonFlags = [
    "-Dbash-completions=true"
    (lib.mesonBool "gtk-doc" withDocs)
  ];
=======
  nativeBuildInputs = [ meson ninja pkg-config gtk-doc docbook_xsl gobject-introspection ];
  buildInputs = [ glib ];

  mesonFlags = [ "-Dbash-completions=true" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = "https://github.com/acrisci/playerctl";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
    broken = stdenv.hostPlatform.isDarwin;
<<<<<<< HEAD
    mainProgram = "playerctl";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
