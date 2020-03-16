{ lib, stdenv, fetchurl, python, pkgconfig, perl, libxslt, docbook_xsl, rpcgen
, fixDarwinDylibNames
, docbook_xml_dtd_42, readline
, popt, iniparser, libbsd, libarchive, libiconv, gettext
, krb5Full, zlib, openldap, cups, pam, avahi, acl, libaio, fam, libceph, glusterfs
, gnutls, ncurses, libunwind, systemd, jansson, lmdb, gpgme, libuuid

, enableLDAP ? false
, enablePrinting ? false
, enableMDNS ? false
, enableDomainController ? false
, enableRegedit ? true
, enableCephFS ? false
, enableGlusterFS ? false
, enableAcl ? (!stdenv.isDarwin)
, enablePam ? (!stdenv.isDarwin)
}:

with lib;

stdenv.mkDerivation rec {
  pname = "samba";
  version = "4.10.11";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${pname}-${version}.tar.gz";
    sha256 = "157qvz8x2s7994rzxhcmpc79cfk86zc0rq5qwg8alvjcw0r457v0";
  };

  outputs = [ "out" "dev" "man" ];

  patches = [
    ./4.x-no-persistent-install.patch
    ./patch-source3__libads__kerberos_keytab.c.patch
    ./4.x-no-persistent-install-dynconfig.patch
    ./4.x-fix-makeflags-parsing.patch
    (fetchurl {
      name = "CVE-2019-14902+CVE-2019-14907+CVE-2019-19344.patch";
      url = "https://www.samba.org/samba/ftp/patches/security/samba-4.10.11-security-2020-01-21.patch";
      sha256 = "1mglfzyb6wv85rrlspqa0hlga1c9f3v123j2dvywrsp3waxhb651";
    })
  ];

  nativeBuildInputs = optionals stdenv.isDarwin [ rpcgen fixDarwinDylibNames ];

  buildInputs = [
    python pkgconfig perl libxslt docbook_xsl docbook_xml_dtd_42 /*
    docbook_xml_dtd_45 */ readline popt iniparser jansson
    libbsd libarchive zlib fam libiconv gettext libunwind krb5Full
  ] ++ optionals stdenv.isLinux [ libaio systemd ]
    ++ optional enableLDAP openldap
    ++ optional (enablePrinting && stdenv.isLinux) cups
    ++ optional enableMDNS avahi
    ++ optionals enableDomainController [ gnutls gpgme lmdb ]
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
  '' + optionalString stdenv.isDarwin ''
     substituteInPlace libcli/dns/wscript_build \
       --replace "bld.SAMBA_BINARY('resolvconftest'" "True or bld.SAMBA_BINARY('resolvconftest'"
  '';

  configureFlags = [
    "--with-static-modules=NONE"
    "--with-shared-modules=ALL"
    "--with-system-mitkrb5"
    "--with-system-mitkdc" krb5Full
    "--enable-fhs"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-rpath"
  ] ++ singleton (if enableDomainController
         then "--with-experimental-mit-ad-dc"
         else "--without-ad-dc")
    ++ optionals (!enableLDAP) [ "--without-ldap" "--without-ads" ]
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

  meta = with stdenv.lib; {
    homepage = "https://www.samba.org";
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aneeshusa ];
  };
}
