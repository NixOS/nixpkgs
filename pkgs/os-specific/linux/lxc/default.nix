{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, perl, docbook2x
, docbook_xml_dtd_45, python3Packages, pam

# Optional Dependencies
, libapparmor ? null, gnutls ? null, libselinux ? null, libseccomp ? null
, libcap ? null, systemd ? null
}:

stdenv.mkDerivation rec {
  pname = "lxc";
  version = "4.0.12";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxc/lxc-${version}.tar.gz";
    sha256 = "1vyk2j5w9gfyh23w3ar09cycyws16mxh3clbb33yhqzwcs1jy96v";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config perl docbook2x python3Packages.wrapPython
  ];
  buildInputs = [
    pam libapparmor gnutls libselinux libseccomp libcap
    python3Packages.python python3Packages.setuptools systemd
  ];

  patches = [
    ./support-db2x.patch
  ];

  postPatch = ''
    sed -i '/chmod u+s/d' src/lxc/Makefile.am
  '';

  XML_CATALOG_FILES = "${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  configureFlags = [
    "--enable-pam"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-api-docs"
    "--with-init-script=none"
    "--with-distro=nixos" # just to be sure it is "unknown"
  ] ++ lib.optional (libapparmor != null) "--enable-apparmor"
    ++ lib.optional (libselinux != null) "--enable-selinux"
    ++ lib.optional (libseccomp != null) "--enable-seccomp"
    ++ lib.optional (libcap != null) "--enable-capabilities"
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
    "bashcompdir=\${out}/share/bash-completion/completions"
    "READMEdir=\${TMPDIR}/var/lib/lxc/rootfs"
    "LXCPATH=\${TMPDIR}/var/lib/lxc"
  ];

  postInstall = ''
    wrapPythonPrograms

    completions=(
      lxc-attach lxc-cgroup lxc-console lxc-destroy lxc-device lxc-execute
      lxc-freeze lxc-info lxc-monitor lxc-snapshot lxc-stop lxc-unfreeze
    )
    pushd $out/share/bash-completion/completions/
      mv lxc lxc-start
      for completion in ''${completions[@]}; do
        ln -sfn lxc-start $completion
      done
    popd
  '';

  meta = with lib; {
    homepage = "https://linuxcontainers.org/";
    description = "Userspace tools for Linux Containers, a lightweight virtualization system";
    license = licenses.lgpl21Plus;

    longDescription = ''
      LXC is the userspace control package for Linux Containers, a
      lightweight virtual system mechanism sometimes described as
      "chroot on steroids". LXC builds up from chroot to implement
      complete virtual systems, adding resource management and isolation
      mechanisms to Linux’s existing process management infrastructure.
    '';

    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
