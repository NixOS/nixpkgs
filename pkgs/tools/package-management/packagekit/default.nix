{ stdenv
, fetchFromGitHub
, lib
, gettext
, glib
, pkg-config
, polkit
, python3
, sqlite
, gobject-introspection
, vala
, gtk-doc
, boost
, meson
, ninja
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, libxml2
, gst_all_1
, gtk3
, enableCommandNotFound ? false
, enableBashCompletion ? false
, bash-completion ? null
, enableSystemd ? stdenv.isLinux
, systemd
}:

stdenv.mkDerivation rec {
  pname = "packagekit";
  version = "1.2.5.1pre";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "PackageKit";
    repo = "PackageKit";
    rev = "30bb82da8d4161330a6d7a20c9989149303421a1";
    sha256 = "k2osc2v0OuGrNjwxdqn785RsbHEJP3p79PG9YqnVE3U=";
  };

  buildInputs = [
    glib
    polkit
    python3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    sqlite
    boost
  ] ++ lib.optional enableSystemd systemd
  ++ lib.optional enableBashCompletion bash-completion;
  nativeBuildInputs = [
    gobject-introspection
    glib
    vala
    gettext
    pkg-config
    gtk-doc
    meson
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    libxml2
    ninja
  ];

  mesonFlags = [
    (if enableSystemd then "-Dsystemd=true" else "-Dsystem=false")
    # often fails to build with nix updates
    # and remounts /nix/store as rw
    # https://github.com/NixOS/nixpkgs/issues/177946
    #"-Dpackaging_backend=nix"
    "-Ddbus_sys=${placeholder "out"}/share/dbus-1/system.d"
    "-Ddbus_services=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dcron=false"
    "-Dgtk_doc=true"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ]
  ++ lib.optional (!enableBashCompletion) "-Dbash_completion=false"
  ++ lib.optional (!enableCommandNotFound) "-Dbash_command_not_found=false";

  postPatch = ''
    # HACK: we want packagekit to look in /etc for configs but install
    # those files in $out/etc ; we just override the runtime paths here
    # same for /var & $out/var
    substituteInPlace etc/meson.build \
      --replace "install_dir: join_paths(get_option('sysconfdir'), 'PackageKit')" "install_dir: join_paths('$out', 'etc', 'PackageKit')"
    substituteInPlace data/meson.build \
      --replace "install_dir: join_paths(get_option('localstatedir'), 'lib', 'PackageKit')," "install_dir: join_paths('$out', 'var', 'lib', 'PackageKit'),"
  '';

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
    homepage = "https://github.com/PackageKit/PackageKit";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
