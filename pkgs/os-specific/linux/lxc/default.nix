{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl, docbook2x
, docbook_xml_dtd_45, systemd, wrapPython
, libapparmor ? null, gnutls ? null, libseccomp ? null, cgmanager ? null
, libnih ? null, dbus ? null, libcap ? null, python3 ? null
}:

let
  enableCgmanager = cgmanager != null && libnih != null && dbus != null;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxc-1.1.2";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    rev = name;
    sha256 = "149nq630h9bg87hb3cn086ci0cz29l7fp3i6qf1mqxv7hnildm8p";
  };

  buildInputs = [
    autoreconfHook pkgconfig perl docbook2x systemd
    libapparmor gnutls libseccomp cgmanager libnih dbus libcap python3
    wrapPython
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

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
    "sysconfigdir=\${out}/etc/default"
    "READMEdir=\${TMPDIR}/var/lib/lxc/rootfs"
    "LXCPATH=\${TMPDIR}/var/lib/lxc"
  ];

  postInstall = "wrapPythonPrograms";

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
    maintainers = with maintainers; [ simons wkennington globin ];
  };
}
