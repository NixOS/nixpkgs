{ lib, stdenv, fetchurl, python, pkgconfig, perl, libxslt, docbook_xsl
, fetchpatch
, docbook_xml_dtd_42, readline, talloc
, popt, iniparser, libbsd, libarchive, libiconv, gettext
, krb5Full, zlib, openldap, cups, pam, avahi, acl, libaio, fam, libceph, glusterfs
, gnutls, ncurses, libunwind, systemd

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
  name = "samba-${version}";
  version = "4.7.12";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${name}.tar.gz";
    sha256 = "0jmg39xigrh48j39r4f1390kmr1p3xbfxzfabln4b0r9qdmki70f";
  };

  outputs = [ "out" "dev" "man" ];

  patches =
    [ ./4.x-no-persistent-install.patch
      ./patch-source3__libads__kerberos_keytab.c.patch
      ./4.x-no-persistent-install-dynconfig.patch
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/samba-team/samba/pull/107.patch";
        sha256 = "0r6q34vjj0bdzmcbnrkad9rww58k4krbwicv4gs1g3dj49skpvd6";
      })
    ];

  buildInputs =
    [ python pkgconfig perl libxslt docbook_xsl docbook_xml_dtd_42 /*
      docbook_xml_dtd_45 */ readline talloc popt iniparser
      libbsd libarchive zlib fam libiconv gettext libunwind krb5Full
    ]
    ++ optionals stdenv.isLinux [ libaio systemd ]
    ++ optional enableLDAP openldap
    ++ optional (enablePrinting && stdenv.isLinux) cups
    ++ optional enableMDNS avahi
    ++ optional enableDomainController gnutls
    ++ optional enableRegedit ncurses
    ++ optional (enableCephFS && stdenv.isLinux) libceph
    ++ optional (enableGlusterFS && stdenv.isLinux) glusterfs
    ++ optional enableAcl acl
    ++ optional enablePam pam;

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
      "--with-system-mitkdc" "${krb5Full}"
      "--enable-fhs"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ]
    ++ [(if enableDomainController
         then "--with-experimental-mit-ad-dc"
         else "--without-ad-dc")]
    ++ optionals (!enableLDAP) [ "--without-ldap" "--without-ads" ]
    ++ optional (!enableAcl) "--without-acl-support"
    ++ optional (!enablePam) "--without-pam";

  # To build in parallel.
  buildPhase = "python buildtools/bin/waf build -j $NIX_BUILD_CORES";

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
    homepage = https://www.samba.org/;
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
