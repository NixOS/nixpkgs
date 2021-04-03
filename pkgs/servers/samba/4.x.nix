{ stdenv
, fetchurl
, python
, pkgconfig
, bison
, flex
, perl
, libxslt
, docbook_xsl
, rpcgen
, fixDarwinDylibNames
, docbook_xml_dtd_45
, readline
, popt
, libbsd
, libarchive
, zlib
, liburing
, fam
, gnutls
, libunwind
, systemd
, jansson
, libtasn1
, tdb
, cmocka
, nixosTests

, enableLDAP ? false, openldap
, enablePrinting ? false, cups
, enableProfiling ? true
, enableMDNS ? false, avahi
, enableDomainController ? false, gpgme, lmdb
, enableRegedit ? true, ncurses
, enableCephFS ? false, libceph
, enableGlusterFS ? false, glusterfs, libuuid
, enableAcl ? (!stdenv.isDarwin), acl
, enablePam ? (!stdenv.isDarwin), pam
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "samba";
  version = "4.12.14";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${pname}-${version}.tar.gz";
    sha256 = "1009hs6nvmvcny3cvjaggx41fc65v95q404y0k7flpinwas8q3s4";
  };

  outputs = [ "out" "dev" "man" ];

  patches = [
    ./4.x-no-persistent-install.patch
    ./patch-source3__libads__kerberos_keytab.c.patch
    ./4.x-no-persistent-install-dynconfig.patch
    ./4.x-fix-makeflags-parsing.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    bison
    flex
    perl
    perl.pkgs.ParseYapp
    libxslt
    docbook_xsl
    docbook_xml_dtd_45
    cmocka
  ] ++ optionals stdenv.isDarwin [
    rpcgen
    fixDarwinDylibNames
  ];

  buildInputs = [
    python
    readline
    popt
    jansson
    libbsd
    libarchive
    zlib
    fam
    libunwind
    gnutls
    libtasn1
    tdb
  ] ++ optionals stdenv.isLinux [ liburing systemd ]
    ++ optional enableLDAP openldap
    ++ optional (enablePrinting && stdenv.isLinux) cups
    ++ optional enableMDNS avahi
    ++ optionals enableDomainController [ gpgme lmdb ]
    ++ optional enableRegedit ncurses
    ++ optional (enableCephFS && stdenv.isLinux) libceph
    ++ optionals (enableGlusterFS && stdenv.isLinux) [ glusterfs libuuid ]
    ++ optional enableAcl acl
    ++ optional enablePam pam;

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions

    # Fix the XML Catalog Paths
    sed -i "s,\(XML_CATALOG_FILES=\"\),\1$XML_CATALOG_FILES ,g" buildtools/wafsamba/wafsamba.py

    patchShebangs ./buildtools/bin
  '';

  configureFlags = [
    "--with-static-modules=NONE"
    "--with-shared-modules=ALL"
    "--enable-fhs"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-rpath"
  ] ++ optional (!enableDomainController)
    "--without-ad-dc"
  ++ optionals (!enableLDAP) [
    "--without-ldap"
    "--without-ads"
  ] ++ optional enableProfiling "--with-profiling-data"
    ++ optional (!enableAcl) "--without-acl-support"
    ++ optional (!enablePam) "--without-pam";

  preBuild = ''
    export MAKEFLAGS="-j $NIX_BUILD_CORES"
  '';

  # Some libraries don't have /lib/samba in RPATH but need it.
  # Use find -type f -executable -exec echo {} \; -exec sh -c 'ldd {} | grep "not found"' \;
  # Looks like a bug in installer scripts.
  postFixup = ''
    export SAMBA_LIBS="$(find $out -type f -name \*.so -exec dirname {} \; | sort | uniq)"
    read -r -d "" SCRIPT << EOF || true
    [ -z "\$SAMBA_LIBS" ] && exit 1;
    BIN='{}';
    OLD_LIBS="\$(patchelf --print-rpath "\$BIN" 2>/dev/null | tr ':' '\n')";
    ALL_LIBS="\$(echo -e "\$SAMBA_LIBS\n\$OLD_LIBS" | sort | uniq | tr '\n' ':')";
    patchelf --set-rpath "\$ALL_LIBS" "\$BIN" 2>/dev/null || exit $?;
    patchelf --shrink-rpath "\$BIN";
    EOF
    find $out -type f -name \*.so -exec $SHELL -c "$SCRIPT" \;
  '';

  passthru = {
    tests.samba = nixosTests.samba;
  };

  meta = with stdenv.lib; {
    homepage = "https://www.samba.org";
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aneeshusa ];
  };
}
