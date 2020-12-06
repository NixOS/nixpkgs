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
, lzma
, pkgconfig
, stdenv
, upower
}:

stdenv.mkDerivation rec {
  pname = "thermald";
  version = "2.4.1";

  outputs = [ "out" "devdoc" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "thermal_daemon";
    rev = "v${version}";
    sha256 = "0rlac7v1b59m7gh767hkd8a0r4p001nd24786fnmryygbxynd2s6";
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    docbook-xsl-nons
    docbook_xml_dtd_412
    gtk-doc
    libtool
    pkgconfig
  ];

  buildInputs = [
    dbus
    dbus-glib
    libevdev
    libxml2
    lzma
    upower
  ];

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--localstatedir=/var"
    "--enable-gtk-doc"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  preConfigure = "NO_CONFIGURE=1 ./autogen.sh";

  postInstall = ''
    cp ./data/thermal-conf.xml $out/etc/thermald/
  '';

  meta = with stdenv.lib; {
    description = "Thermal Daemon";
    homepage = "https://01.org/linux-thermal-daemon";
    changelog = "https://github.com/intel/thermal_daemon/blob/master/README.txt";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
