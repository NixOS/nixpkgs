{ lib
, fetchFromGitHub
, stdenv
, acl
, gnome
, glibmm_2_68
, gtkmm4
, meson
, ninja
, pkg-config
, itstool
, wrapGAppsHook4
, gtk4
}:

stdenv.mkDerivation rec {
  pname = "eiciel";
  version = "0.10.0";

  outputs = [ "out" "nautilusExtension" ];

  src = fetchFromGitHub {
    owner = "rofirrim";
    repo = "eiciel";
    rev = version;
    sha256 = "0lhnrxhbg80pqjy9f8yiqi7x48rb6m2cmkffv25ssjynsmdnar0s";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    wrapGAppsHook4
    gtk4
  ];

  buildInputs = [
    acl
    glibmm_2_68
    gtkmm4
    gnome.nautilus
  ];

  mesonFlags = [
    "-Dnautilus-extension-dir=${placeholder "nautilusExtension"}/lib/nautilus/extensions-4"
  ];

  meta = with lib; {
    description = "Graphical editor for ACLs and extended attributes";
    homepage = "https://rofi.roger-ferrer.org/eiciel/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sersorrel ];
    platforms = platforms.linux;
    mainProgram = "eiciel";
  };
}
