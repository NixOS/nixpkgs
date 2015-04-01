{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl, docbook2x
, docbook_xml_dtd_45, systemd
, libapparmor ? null, gnutls ? null, libseccomp ? null, cgmanager ? null
, libnih ? null, dbus ? null, libcap ? null
}:

let
  enableCgmanager = cgmanager != null && libnih != null && dbus != null;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxc-1.1.1";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    rev = name;
    sha256 = "04zpznd364862y3dwn97klvwfw9i2b6n1lh4fkci0z74c6z9svql";
  };

  buildInputs = [
    autoreconfHook pkgconfig perl docbook2x systemd
    libapparmor gnutls libseccomp cgmanager libnih dbus libcap
  ];

  patches = [ ./support-db2x.patch ];

  XML_CATALOG_FILES = "${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-rootfs-path=/var/lib/lxc/rootfs"
  ] ++ optional (libapparmor != null) "--enable-apparmor"
    ++ optional (gnutls != null) "--enable-gnutls"
    ++ optional (libseccomp != null) "--enable-seccomp"
    ++ optional (enableCgmanager) "--enable-cgmanager"
    ++ optional (libcap != null) "--enable-capabilities"
    ++ [
    "--enable-doc"
    "--enable-tests"
  ];

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall = ''
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done

    # Remove the unneeded var/lib directories
    rm -rf $out/var
  '';

  meta = {
    homepage = "http://lxc.sourceforge.net";
    description = "userspace tools for Linux Containers, a lightweight virtualization system";
    license = licenses.lgpl21Plus;

    longDescription = ''
      LXC is the userspace control package for Linux Containers, a
      lightweight virtual system mechanism sometimes described as
      "chroot on steroids". LXC builds up from chroot to implement
      complete virtual systems, adding resource management and isolation
      mechanisms to Linux’s existing process management infrastructure.
    '';

    platforms = platforms.linux;
    maintainers = with maintainers; [ simons wkennington ];
  };
}
