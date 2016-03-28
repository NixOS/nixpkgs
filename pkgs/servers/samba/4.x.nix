{ lib, stdenv, fetchurl, python, pkgconfig, perl, libxslt, docbook_xsl
, docbook_xml_dtd_42, docbook_xml_dtd_45, readline, talloc, ntdb, tdb, tevent
, ldb, popt, iniparser, libbsd, libarchive, libiconv, gettext
, kerberos, zlib, openldap, cups, pam, avahi, acl, libaio, fam, libceph, glusterfs
, gnutls, libgcrypt, libgpgerror
, ncurses, libunwind, libibverbs, librdmacm, systemd

, enableInfiniband ? false
, enableLDAP ? false
, enablePrinting ? false
, enableMDNS ? false
, enableDomainController ? false
, enableRegedit ? true
, enableCephFS ? false
, enableGlusterFS ? false
}:

with lib;

stdenv.mkDerivation rec {
  name = "samba-4.3.6";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${name}.tar.gz";
    sha256 = "0929fpk2pq4v389naai519xvsm9bzpar4jlgjxwlx1cnn6jyql9j";
  };

  patches =
    [ ./4.x-no-persistent-install.patch
      ./4.x-fix-ctdb-deps.patch
    ];

  buildInputs =
    [ python pkgconfig perl libxslt docbook_xsl docbook_xml_dtd_42 /*
      docbook_xml_dtd_45 */ readline talloc ntdb tdb tevent ldb popt iniparser
      libbsd libarchive zlib acl fam libiconv gettext libunwind kerberos
    ]
    ++ optionals stdenv.isLinux [ libaio pam systemd ]
    ++ optionals (enableInfiniband && stdenv.isLinux) [ libibverbs librdmacm ]
    ++ optional enableLDAP openldap
    ++ optional (enablePrinting && stdenv.isLinux) cups
    ++ optional enableMDNS avahi
    ++ optional enableDomainController gnutls
    ++ optional enableRegedit ncurses
    ++ optional (enableCephFS && stdenv.isLinux) libceph
    ++ optional (enableGlusterFS && stdenv.isLinux) glusterfs;

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions

    # Fix the XML Catalog Paths
    sed -i "s,\(XML_CATALOG_FILES=\"\),\1$XML_CATALOG_FILES ,g" buildtools/wafsamba/wafsamba.py
  '';

  configureFlags =
    [ "--with-static-modules=NONE"
      "--with-shared-modules=ALL"
      "--with-system-mitkrb5"
      "--enable-fhs"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--bundled-libraries=NONE"
      "--private-libraries=NONE"
      "--builtin-libraries=NONE"
    ]
    ++ optional (!enableDomainController) "--without-ad-dc"
    ++ optionals (!enableLDAP) [ "--without-ldap" "--without-ads" ];

  enableParallelBuilding = true;

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
    homepage = http://www.samba.org/;
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}
