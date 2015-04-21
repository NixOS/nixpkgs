{ stdenv, fetchurl, python, pkgconfig, perl, libxslt, docbook_xsl
, docbook_xml_dtd_42, docbook_xml_dtd_45, readline, talloc, ntdb, tdb, tevent
, ldb, popt, iniparser, pythonPackages, libbsd, nss_wrapper, socket_wrapper
, uid_wrapper, libarchive

# source3/wscript optionals
, kerberos ? null
, zlib ? null
, openldap ? null
, cups ? null
, pam ? null
, avahi ? null
, acl ? null
, libaio ? null
, fam ? null
, libceph ? null
, glusterfs ? null

# buildtools/wafsamba/wscript optionals
, libiconv ? null
, gettext ? null

# source4/lib/tls/wscript optionals
, gnutls ? null
, libgcrypt ? null
, libgpgerror ? null

# other optionals
, ncurses ? null
, libunwind ? null
, dbus ? null
, libibverbs ? null
, librdmacm ? null
, systemd ? null
}:

assert kerberos != null -> zlib != null;

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  bundledLibs = if kerberos != null && kerberos.implementation == "heimdal" then "NONE" else "com_err";
  hasGnutls = gnutls != null && libgcrypt != null && libgpgerror != null;
  isKrb5OrNull = if kerberos != null && kerberos.implementation == "krb5" then true else null;
  hasInfinibandOrNull = if libibverbs != null && librdmacm != null then true else null;
in
stdenv.mkDerivation rec {
  name = "samba-4.2.1";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${name}.tar.gz";
    sha256 = "1hsakc8h6rs48xr6i55m90pd53hpxcqjjnlwq8i2rp0nq4ws5sip";
  };

  patches = [
    ./4.x-no-persistent-install.patch
    ./4.x-fix-ctdb-deps.patch
  ] ++ stdenv.lib.optional (kerberos != null) ./4.x-heimdal-compat.patch;

  buildInputs = [
    python pkgconfig perl libxslt docbook_xsl docbook_xml_dtd_42
    docbook_xml_dtd_45 readline talloc ntdb tdb tevent ldb popt iniparser
    pythonPackages.subunit libbsd nss_wrapper socket_wrapper uid_wrapper
    libarchive

    kerberos zlib openldap cups pam avahi acl libaio fam libceph glusterfs

    libiconv gettext

    gnutls libgcrypt libgpgerror

    ncurses libunwind dbus libibverbs librdmacm systemd
  ];

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions

    # Fix the XML Catalog Paths
    sed -i "s,\(XML_CATALOG_FILES=\"\),\1$XML_CATALOG_FILES ,g" buildtools/wafsamba/wafsamba.py
  '';

  enableParallelBuilding = true;

  configureFlags = [
    # source3/wscript options
    (mkWith   true                 "static-modules"    "NONE")
    (mkWith   true                 "shared-modules"    "ALL")
    (mkWith   true                 "winbind"           null)
    (mkWith   (openldap != null)   "ads"               null)
    (mkWith   (openldap != null)   "ldap"              null)
    (mkEnable (cups != null)       "cups"              null)
    (mkEnable (cups != null)       "iprint"            null)
    (mkWith   (pam != null)        "pam"               null)
    (mkWith   (pam != null)        "pam_smbpass"       null)
    (mkWith   true                 "quotas"            null)
    (mkWith   true                 "sendfile-support"  null)
    (mkWith   true                 "utmp"              null)
    (mkWith   true                 "utmp"              null)
    (mkEnable true                 "pthreadpool"       null)
    (mkEnable (avahi != null)      "avahi"             null)
    (mkWith   true                 "iconv"             null)
    (mkWith   (acl != null)        "acl-support"       null)
    (mkWith   true                 "dnsupdate"         null)
    (mkWith   true                 "syslog"            null)
    (mkWith   true                 "automount"         null)
    (mkWith   (libaio != null)     "aio-support"       null)
    (mkWith   (fam != null)        "fam"               null)
    (mkWith   (libarchive != null) "libarchive"        null)
    (mkWith   true                 "cluster-support"   null)
    (mkWith   (ncurses != null)    "regedit"           null)
    (mkWith   libceph              "libcephfs"         libceph)
    (mkEnable (glusterfs != null)  "glusterfs"         null)

    # dynconfig/wscript options
    (mkEnable true                 "fhs"               null)
    (mkOther                       "sysconfdir"        "/etc")
    (mkOther                       "localstatedir"     "/var")

    # buildtools/wafsamba/wscript options
    (mkOther                       "bundled-libraries" bundledLibs)
    (mkOther                       "private-libraries" "NONE")
    (mkOther                       "builtin-libraries" "replace")
    (mkWith   libiconv             "libiconv"          libiconv)
    (mkWith   (gettext != null)    "gettext"           gettext)

    # source4/lib/tls/wscript options
    (mkEnable hasGnutls            "gnutls" null)

    # wscript options
    (mkWith   isKrb5OrNull         "system-mitkrb5"    null)
    (if hasGnutls then null else "--without-ad-dc")

    # ctdb/wscript
    (mkEnable hasInfinibandOrNull  "infiniband"        null)
    (mkEnable null                 "pmda"              null)
  ];

  stripAllList = [ "bin" "sbin" ];

  postInstall = ''
    # Remove unecessary components
    rm -r $out/{lib,share}/ctdb-tests
    rm $out/bin/ctdb_run{_cluster,}_tests
  '';

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
