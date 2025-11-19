{
  lib,
  stdenv,
  docbook_xml_dtd_44,
  docbook_xml_dtd_45,
  docbook_xsl,
  asciidoctor,
  fetchurl,
  flex,
  kmod,
  libxslt,
  nixosTests,
  perl,
  perlPackages,
  systemd,
  keyutils,
  udevCheckHook,
  gettext,

  # drbd-utils are compiled twice, once with forOCF = true to extract
  # its OCF definitions for use in the ocf-resource-agents derivation,
  # then again with forOCF = false, where the ocf-resource-agents is
  # provided as the OCF_ROOT.
  forOCF ? false,
  ocf-resource-agents,
}:

stdenv.mkDerivation rec {
  pname = "drbd";
  version = "9.33.0";

  src = fetchurl {
    url = "https://pkg.linbit.com/downloads/drbd/utils/${pname}-utils-${version}.tar.gz";
    hash = "sha256-Ij/gfQtkbpkbM7qepBRo+aZvkDVi59p2bdD8a06jPbk=";
  };

  nativeBuildInputs = [
    flex
    libxslt
    docbook_xsl
    asciidoctor
    keyutils
    udevCheckHook
    gettext
  ];

  buildInputs = [
    perl
    perlPackages.Po4a
    gettext
  ];

  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
    "--sbindir=${placeholder "out"}/bin"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--without-distro"
  ];

  makeFlags = [
    "SOURCE_DATE_EPOCH=1"
    "WANT_DRBD_REPRODUCIBLE_BUILD=1"
  ]
  ++ lib.optional (!forOCF) "OCF_ROOT=${ocf-resource-agents}/usr/lib/ocf}";

  installFlags = [
    "prefix="
    "DESTDIR=${placeholder "out"}"
    "localstatedir=/var"
    "DRBD_LIB_DIR=/var/lib"
    "INITDIR=/etc/init.d"
    "udevrulesdir=/etc/udev/rules.d"
    "sysconfdir=/etc"
    "sbindir=/bin"
    "datadir="
    "LIBDIR=/lib/drbd"
    "mandir=/share/man"
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace user/v84/drbdadm_usage_cnt.c \
      --replace '"/lib/drbd");' \
                '"${placeholder "out"}/lib/drbd");'
    substituteInPlace user/v9/drbdsetup_linux.c \
      --replace 'ret = system("/sbin/modprobe drbd");' \
                'ret = system("${kmod}/bin/modprobe drbd");'
    substituteInPlace user/v84/drbdsetup.c \
      --replace 'system("/sbin/modprobe drbd")' \
                'system("${kmod}/bin/modprobe drbd")'
    substituteInPlace documentation/ra2refentry.xsl \
      --replace "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" \
                "${docbook_xml_dtd_44}/xml/dtd/docbook/docbookx.dtd"
    function patch_docbook45() {
      substituteInPlace $1 \
        --replace "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
                  "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
    }
    patch_docbook45 documentation/v9/drbd.conf.xml.in
    patch_docbook45 documentation/v9/drbdsetup.xml.in
    patch_docbook45 documentation/v84/drbdsetup.xml
    patch_docbook45 documentation/v84/drbd.conf.xml
    substituteInPlace user/v9/drbdtool_common.c \
      --replace 'add_component_to_path("/lib/drbd");' \
                'add_component_to_path("${placeholder "out"}/lib/drbd");'
  '';

  preConfigure = ''
    export PATH=${systemd}/sbin:$PATH
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;

  passthru.tests.drbd = nixosTests.drbd;

  meta = with lib; {
    homepage = "https://linbit.com/drbd/";
    description = "Distributed Replicated Block Device, a distributed storage system for Linux (userspace utilities)";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      ryantm
      astro
      birkb
    ];
    longDescription = ''
      DRBD is a software-based, shared-nothing, replicated storage solution
      mirroring the content of block devices (hard disks, partitions, logical volumes etc.) between hosts.
    '';
  };
}
