{ stdenv, fetchurl, python, pkgconfig, perl, libxslt, docbook_xsl_ns
, docbook_xml_dtd_42, readline, talloc, ntdb, tdb, tevent, ldb, popt, iniparser
, pythonPackages, libbsd, nss_wrapper, socket_wrapper, uid_wrapper, libarchive

# source3/wscript optionals
, kerberos ? null
, openldap ? null
, cups ? null
, pam ? null
, avahi ? null
, acl ? null
, libaio ? null
, fam ? null
, ceph ? null
, glusterfs ? null

# buildtools/wafsamba/wscript optionals
, libiconv ? null
, gettext ? null

# source4/lib/tls/wscript optionals
, gnutls ? null
, libgcrypt ? null
, libgpgerror ? null

# other optionals
, zlib ? null
, ncurses ? null
, libcap ? null
}:

stdenv.mkDerivation rec {
  name = "samba-4.2.0";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${name}.tar.gz";
    sha256 = "03s9pjdgq6nlv2lcnlmxlhhj8m5drgv6z4xy9zkgwwd92mw0b9k6";
  };

  patches = [
    ./4.x-no-persistent-install.patch
    ./4.x-heimdal-compat.patch
  ];

  buildInputs = [
    python pkgconfig perl libxslt docbook_xsl_ns docbook_xml_dtd_42
    readline talloc ntdb tdb tevent ldb popt iniparser pythonPackages.subunit
    libbsd nss_wrapper socket_wrapper uid_wrapper libarchive

    kerberos openldap cups pam avahi acl libaio fam ceph glusterfs

    libiconv gettext

    gnutls libgcrypt libgpgerror

    zlib ncurses libcap
  ];

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions
  '';

  enableParallelBuilding = true;

  configureFlags = [
    # source3/wscript options
    "--with-static-modules=NONE"
    "--with-shared-modules=ALL"
    "--with-winbind"
  ] ++ (if kerberos != null then [ "--with-ads" ] else [ "--without-ads" ])
    ++ (if openldap != null then [ "--with-ldap" ] else [ "--without-ldap" ])
    ++ (if cups != null then [ "--enable-cups" ] else [ "--disable-cups" ])
    ++ (if pam != null then [ "--with-pam" "--with-pam_smbpass" ]
        else [ "--without-pam" "--without-pam_smbpass" ]) ++ [
    "--with-quotas"
    "--with-sendfile-support"
    "--with-utmp"
    "--enable-pthreadpool"
  ] ++ (if avahi != null then [ "--enable-avahi" ] else [ "--disable-avahi" ]) ++ [
    "--with-iconv"
  ] ++ (if acl != null then [ "--with-acl-support" ] else [ "--without-acl-support" ]) ++ [
    "--with-dnsupdate"
    "--with-syslog"
    "--with-automount"
  ] ++ (if libaio != null then [ "--with-aio-support" ] else [ "--without-aio-support" ])
    ++ (if fam != null then [ "--with-fam" ] else [ "--without-fam" ]) ++ [
    "--with-cluster-support"
  ] ++ (if ceph != null then [ "--with-libcephfs=${ceph}" ] else [ ])
    ++ (if glusterfs != null then [ "--enable-glusterfs" ] else [ "--disable-glusterfs" ]) ++ [

    # dynconfig/wscript options
    "--enable-fhs"
    "--sysconfdir=/etc"
    "--localstatedir=/var"

    # buildtools/wafsamba/wscript options
    "--bundled-libraries=${if kerberos != null && kerberos.implementation == "heimdal" then "NONE" else "com_err"}"
    "--private-libraries=NONE"
    "--builtin-libraries=replace"
  ] ++ (if libiconv != null then [ "--with-libiconv=${libiconv}" ] else [ ])
    ++ (if gettext != null then [ "--with-gettext=${gettext}" ] else [ "--without-gettext" ]) ++ [

    # source4/lib/tls/wscript options
  ] ++ (if gnutls != null && libgcrypt != null && libgpgerror != null
        then [ "--enable-gnutls" ] else [ "--disable-gnutls" ]) ++ [

    # wscript options
  ] ++ stdenv.lib.optional (kerberos != null && kerberos.implementation == "krb5") "--with-system-mitkrb5"
    ++ stdenv.lib.optional (kerberos == null) "--without-ad-dc" ++ [

    # ctdb/wscript
    "--enable-infiniband"
    "--enable-pmda"
  ];

  stripAllList = [ "bin" "sbin" ];

  postFixup = ''
    export SAMBA_LIBS="$(find $out -type f -name \*.so -exec dirname {} \; | sort | uniq)"
    read -r -d "" SCRIPT << EOF
    [ -z "\$SAMBA_LIBS" ] && exit 1;
    BIN='{}';
    OLD_LIBS="\$(patchelf --print-rpath "\$BIN" 2>/dev/null | tr ':' '\n')";
    ALL_LIBS="\$(echo -e "\$SAMBA_LIBS\n\$OLD_LIBS" | sort | uniq | tr '\n' ':')";
    patchelf --set-rpath "\$ALL_LIBS" "\$BIN" 2>/dev/null || exit $?;
    patchelf --shrink-rpath "\$BIN";
    EOF
    find $out -type f -exec $SHELL -c "$SCRIPT" \;
  '';

  meta = with stdenv.lib; {
    homepage = http://www.samba.org/;
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}
