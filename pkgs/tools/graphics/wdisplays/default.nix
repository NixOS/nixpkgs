{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, gtk3, epoxy, wayland, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "wdisplays";
  version = "unstable-2021-04-03";

  nativeBuildInputs = [ meson ninja pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 epoxy wayland ];

  src = fetchFromGitHub {
    owner = "luispabon";
    repo = "wdisplays";
    rev = "7f2eac0d2aa81b5f495da7950fd5a94683f7868e";
    sha256 = "sha256-cOF3+T34zPro58maWUouGG+vlLm2C5NfcH7PZhSvApE=";
  };

  meta = with lib; {
    description = "A graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/luispabon/wdisplays";
    maintainers = with maintainers; [ lheckemann ma27 ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
