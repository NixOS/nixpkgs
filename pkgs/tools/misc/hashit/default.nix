{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, cmake, vala_0_40, python3, gnome3, gtk3, granite, gobject-introspection, desktop-file-utils, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "hashit";
  version = "1.0.0";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = pname;
    rev = version;
    sha256 = "1ba38qmwdk7vkarsxqn89irbymzx52gbks4isx0klg880xm2z4dv";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.defaultIconTheme # should be `elementary.defaultIconTheme`when elementary attribute set is merged
    gnome3.libgee
    granite
    gtk3
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A simple app for checking usual checksums";
    homepage = https://github.com/artemanufrij/hashit;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
