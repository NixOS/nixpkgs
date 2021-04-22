{ lib
, stdenv
, fetchurl
, flex
, systemd
, perl
, docbook_xsl
, libxslt
, docbook_xml_dtd_44
, docbook_xml_dtd_45
, resource-agents
, kmod
}:

stdenv.mkDerivation rec {
  pname = "drbd-utils";
  version = "9.16.0";

  src = fetchurl {
    url = "https://linbit.com/downloads/drbd/utils/${pname}-${version}.tar.gz";
    sha256 = "sha256:0s1dgg4nvvvxzh9qrah3n15b92h38b8m9pa43s14fdjdg11m6wk2";
  };

  nativeBuildInputs = [
    flex
    libxslt
    docbook_xsl
    resource-agents
  ];

  buildInputs = [
    perl
    # perlPackages.Po4a used by ja documentation
  ];

  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
    "--sbindir=${placeholder "out"}/bin"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--without-distro"
  ];

  makeFlags = [
    "OCF_ROOT=${resource-agents}/lib/ocf"
    "SOURCE_DATE_EPOCH=1"
    "WANT_DRBD_REPRODUCIBLE_BUILD=1"
  ];

  installFlags = [
    "prefix="
    "DESTDIR=${placeholder "out"}"
    "localstatedir=/var"
    "DRBD_LIB_DIR=/var/lib"
    "INITDIR=/etc/init.d"
    "udevrulesdir=/lib"
    "sysconfdir=/etc"
    "sbindir=/bin"
    "datadir="
    "LIBDIR=/lib/drbd"
    "mandir=/share/man"
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace user/v84/drbdadm_usage_cnt.c \
      --replace '			"/lib/drbd");' \
                '			"${placeholder "out"}/lib/drbd");'
    substituteInPlace user/v9/drbdsetup_linux.c \
      --replace '		ret = system("/sbin/modprobe drbd");' \
                '		ret = system("${kmod}/bin/modprobe drbd");'
    substituteInPlace user/v84/drbdsetup.c \
      --replace 'system("/sbin/modprobe drbd")' \
                'system("${kmod}/bin/modprobe drbd")'
    substituteInPlace documentation/ra2refentry.xsl \
      --replace "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" \
                "${docbook_xml_dtd_44}/xml/dtd/docbook/docbookx.dtd"
    substituteInPlace documentation/v9/drbd.conf.xml.in \
      --replace "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
                "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
    substituteInPlace documentation/v9/drbdsetup.xml.in \
      --replace "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
                "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
    substituteInPlace documentation/v84/drbdsetup.xml \
      --replace "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
                "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
    substituteInPlace documentation/v84/drbd.conf.xml \
      --replace "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
                "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
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
      --replace '	add_component_to_path("/lib/drbd");' \
                '	add_component_to_path("${placeholder "out"}/lib/drbd");'
  '';

  preConfigure = ''
    export PATH=${systemd}/sbin:$PATH
  '';

  meta = with lib; {
    homepage = "https://linbit.com/drbd/";
    description = "DRBD userspace utilities";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ryantm ];
  };
}
