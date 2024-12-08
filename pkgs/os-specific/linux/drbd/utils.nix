{ lib
, stdenv
, docbook_xml_dtd_44
, docbook_xml_dtd_45
, docbook_xsl
, asciidoctor
, fetchurl
, flex
, kmod
, libxslt
, nixosTests
, perl
, perlPackages
, systemd
, keyutils

# drbd-utils are compiled twice, once with forOCF = true to extract
# its OCF definitions for use in the ocf-resource-agents derivation,
# then again with forOCF = false, where the ocf-resource-agents is
# provided as the OCF_ROOT.
, forOCF ? false
, ocf-resource-agents
}:

stdenv.mkDerivation rec {
  pname = "drbd";
  version = "9.27.0";

  src = fetchurl {
    url = "https://pkg.linbit.com/downloads/drbd/utils/${pname}-utils-${version}.tar.gz";
    sha256 = "1qwdrjrgas8z8vc6c85xcrqaczjwyqd61yig01n44wa5z0j3v4aq";
  };

  nativeBuildInputs = [
    flex
    libxslt
    docbook_xsl
    asciidoctor
    keyutils
  ];

  buildInputs = [
    perl
    perlPackages.Po4a
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
  ] ++ lib.optional (!forOCF) "OCF_ROOT=${ocf-resource-agents}/usr/lib/ocf}";

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
    # The ja documentation is disabled because:
    # make[1]: Entering directory '/build/drbd-utils-9.16.0/documentation/ja/v84'
    # /nix/store/wyx2nn2pjcn50lc95c6qgsgm606rn0x2-perl5.32.1-po4a-0.62/bin/po4a-translate -f docbook -M utf-8 -L utf-8 -keep 0 -m ../../v84/drbdsetup.xml -p drbdsetup.xml.po -l drbdsetup.xml
    # Use of uninitialized value $args[1] in sprintf at /nix/store/wyx2nn2pjcn50lc95c6qgsgm606rn0x2-perl5.32.1-po4a-0.62/lib/perl5/site_perl/Locale/Po4a/Common.pm line 134.
    # Invalid po file drbdsetup.xml.po:
    substituteInPlace Makefile.in \
      --replace 'DOC_DIRS    := documentation/v9 documentation/ja/v9' \
                'DOC_DIRS    := documentation/v9' \
      --replace 'DOC_DIRS    += documentation/v84 documentation/ja/v84' \
                'DOC_DIRS    += documentation/v84' \
      --replace '$(MAKE) -C documentation/ja/v9 doc' \
                "" \
      --replace '$(MAKE) -C documentation/ja/v84 doc' \
                ""
    substituteInPlace user/v9/drbdtool_common.c \
      --replace 'add_component_to_path("/lib/drbd");' \
                'add_component_to_path("${placeholder "out"}/lib/drbd");'
  '';

  preConfigure = ''
    export PATH=${systemd}/sbin:$PATH
  '';

  enableParallelBuilding = true;

  passthru.tests.drbd = nixosTests.drbd;

  meta = with lib; {
    homepage = "https://linbit.com/drbd/";
    description = "Distributed Replicated Block Device, a distributed storage system for Linux (userspace utilities)";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ryantm astro birkb ];
    longDescription = ''
       DRBD is a software-based, shared-nothing, replicated storage solution
       mirroring the content of block devices (hard disks, partitions, logical volumes, and so on) between hosts.
    '';
  };
}
