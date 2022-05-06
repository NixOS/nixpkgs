{ autoconf
, autoconf-archive
, automake
, dbus
, dbus-glib
, docbook_xml_dtd_412
, docbook-xsl-nons
, fetchFromGitHub
, gtk-doc
, libevdev
, libtool
, libxml2
, xz
, pkg-config
, lib, stdenv
, upower
}:

stdenv.mkDerivation rec {
  pname = "thermald";
  version = "2.4.9";

  outputs = [ "out" "devdoc" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "thermal_daemon";
    rev = "v${version}";
    sha256 = "sha256-82O4vrUo3lMNzGOI5WyV1eponF0za0WM6mtd54xqUh8=";
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    docbook-xsl-nons
    docbook_xml_dtd_412
    gtk-doc
    libtool
    pkg-config
  ];

  buildInputs = [
    dbus
    dbus-glib
    libevdev
    libxml2
    xz
    upower
  ];

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--localstatedir=/var"
    "--enable-gtk-doc"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--disable-werror"
  ];

  preConfigure = "NO_CONFIGURE=1 ./autogen.sh";

  postInstall = ''
    cp ./data/thermal-conf.xml $out/etc/thermald/
  '';

  meta = with lib; {
    description = "Thermal Daemon";
    homepage = "https://github.com/intel/thermal_daemon";
    changelog = "https://github.com/intel/thermal_daemon/blob/master/README.txt";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
