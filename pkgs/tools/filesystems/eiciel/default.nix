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
  version = "0.10.0-rc2";

  outputs = [ "out" "nautilusExtension" ];

  src = fetchFromGitHub {
    owner = "rofirrim";
    repo = "eiciel";
    rev = version;
    sha256 = "+MXoT6J4tKuFaSvUTcM15cKWLUnS0kYgBfqH+5lz6KY=";
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

  postPatch = ''
    # https://github.com/rofirrim/eiciel/pull/9
    substituteInPlace meson.build --replace "compiler.find_library('libacl')" "compiler.find_library('acl')"
  '';

  meta = with lib; {
    description = "Graphical editor for ACLs and extended attributes";
    homepage = "https://rofi.roger-ferrer.org/eiciel/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sersorrel ];
    platforms = platforms.linux;
  };
}
