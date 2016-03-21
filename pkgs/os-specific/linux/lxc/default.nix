{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, perl, docbook2x
, docbook_xml_dtd_45, python3Packages

# Optional Dependencies
, libapparmor ? null, gnutls ? null, libselinux ? null, libseccomp ? null
, cgmanager ? null, libnih ? null, dbus ? null, libcap ? null, systemd ? null
}:

let
  enableCgmanager = cgmanager != null && libnih != null && dbus != null;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxc-${version}";
  version = "1.1.5";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxc/lxc-${version}.tar.gz";
    sha256 = "1gnhgs4i2zamfdydj895inr9i072658wd47nf1ryw5710hdsv24m";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig perl docbook2x python3Packages.wrapPython
  ];
  buildInputs = [
    libapparmor gnutls libselinux libseccomp cgmanager libnih dbus libcap
    python3Packages.python systemd
  ];

  patches = [
    ./support-db2x.patch
    (fetchpatch {
      url = "https://github.com/lxc/lxc/commit/3db8dd39a797f87f8b348f1b6b44953a25f3f170.patch";
      sha256 = "0scbzm9dqqhqsl0ri8da8a34r4qj9ph0cg68l9s7gw01vpvqbs8l";
    })
  ];

  XML_CATALOG_FILES = "${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--enable-doc"
    "--disable-api-docs"
    "--with-init-script=none"
    "--with-distro=nixos" # just to be sure it is "unknown"
  ] ++ optional (libapparmor != null) "--enable-apparmor"
    ++ optional (libselinux != null) "--enable-selinux"
    ++ optional (libseccomp != null) "--enable-seccomp"
    ++ optional (libcap != null) "--enable-capabilities"
    ++ [
    "--disable-examples"
    "--enable-python"
    "--disable-lua"
    "--enable-bash"
    (if doCheck then "--enable-tests" else "--disable-tests")
    "--with-rootfs-path=/var/lib/lxc/rootfs"
  ];

  doCheck = false;

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
    "sysconfigdir=\${out}/etc/default"
    "READMEdir=\${TMPDIR}/var/lib/lxc/rootfs"
    "LXCPATH=\${TMPDIR}/var/lib/lxc"
  ];

  postInstall = ''
    wrapPythonPrograms
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
    maintainers = with maintainers; [ simons wkennington globin fpletz ];
  };
}
