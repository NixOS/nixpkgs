{ lib
, fetchFromGitHub
, stdenv
, acl
, gnome
, gtkmm3
, meson
, ninja
, pkg-config
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "eiciel";
  version = "0.9.13.1";

  outputs = [ "out" "nautilusExtension" ];

  src = fetchFromGitHub {
    owner = "rofirrim";
    repo = "eiciel";
    rev = version;
    sha256 = "0rhhw0h1hyg5kvxhjxkdz03vylgax6912mg8j4lvcz6wlsa4wkvj";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    acl
    gtkmm3
    gnome.nautilus
  ];

  mesonFlags = [
    "-Dnautilus-extension-dir=${placeholder "nautilusExtension"}/lib/nautilus/extensions-3.0"
  ];

  postPatch = ''
    substituteInPlace meson.build --replace "compiler.find_library('libacl')" "compiler.find_library('acl')"
    chmod +x img/install_icons.sh
    patchShebangs img/install_icons.sh
  '';

  meta = with lib; {
    description = "Graphical editor for ACLs and extended attributes";
    homepage = "https://rofi.roger-ferrer.org/eiciel/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sersorrel ];
    platforms = platforms.linux;
  };
}
