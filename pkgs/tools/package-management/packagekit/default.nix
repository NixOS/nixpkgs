{ stdenv, fetchFromGitHub, lib
, intltool, glib, pkgconfig, polkit, python3, sqlite
, gobject-introspection, vala, gtk-doc
, nix, boost, meson, ninja, nlohmann_json
, libxslt, libxml2, gst_all_1, gtk3
, enableCommandNotFound ? false
, enableBashCompletion ? false, bash-completion ? null
, enableSystemd ? stdenv.isLinux, systemd }:

stdenv.mkDerivation rec {
  pname = "packagekit";
  version = "1.2.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "PackageKit";
    rev = "9a17f5e31d29df998c6254666cb0253536b3ab95";
    sha256 = "009b1w06v0igqvsk0l8sndi28m6kqv3clbgx574gs8hv01gffwjn";
  };

  buildInputs = [
    glib
    polkit
    python3
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    nlohmann_json
  ] ++ lib.optional enableSystemd systemd
    ++ lib.optional enableBashCompletion bash-completion;
  propagatedBuildInputs = [
    sqlite
    boost
    nix
  ];
  nativeBuildInputs = [
    vala
    intltool
    pkgconfig
    gtk-doc
    meson
    libxslt
    libxml2
    ninja
  ];

  mesonFlags = [
    (if enableSystemd then "-Dsystemd=true" else "-Dsystem=false")
    "-Dpackaging_backend=nix"
    "-Ddbus_sys=${placeholder "out"}/share/dbus-1/system.d"
    "-Ddbus_services=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dcron=false"
    "-Dman_pages=false"
  ]
  ++ lib.optional (!enableBashCompletion) "-Dbash_completion=false"
  ++ lib.optional (!enableCommandNotFound) "-Dbash_command_not_found=false";

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with lib; {
    description = "System to facilitate installing and updating packages";
    longDescription = ''
      PackageKit is a system designed to make installing and updating software
      on your computer easier. The primary design goal is to unify all the
      software graphical tools used in different distributions, and use some of
      the latest technology like PolicyKit. The actual nuts-and-bolts distro
      tool (dnf, apt, etc) is used by PackageKit using compiled and scripted
      helpers. PackageKit isn't meant to replace these tools, instead providing
      a common set of abstractions that can be used by standard GUI and text
      mode package managers.
    '';
    homepage = "http://www.packagekit.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
