{ stdenv, fetchurl, python, pkgconfig, perl, libxslt, docbook_xsl_ns
, docbook_xml_dtd_42, readline, talloc, ntdb, tdb, tevent, ldb, popt, iniparser
, pythonPackages

# source3/wscript optionals
, heimdal ? null # Samba only supports heimdal for kerberos although mit-krb5 is being worked on
, openldap ? null
, cups ? null
, pam ? null
, avahi ? null
, acl ? null
, libaio ? null
, fam ? null
, ctdb ? null
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
  name = "samba-4.1.14";

  src = fetchurl {
    url = "http://samba.org/samba/ftp/stable/${name}.tar.gz";
    sha256 = "1ficvglapxcw4zrgwkmmjbprsqrxks3ii29nblsr4wlrram4p8ay";
  };

  patches = [ ./4.x-no-persistent-install.patch ];

  buildInputs = [
    python pkgconfig perl libxslt docbook_xsl_ns docbook_xml_dtd_42
    readline talloc ntdb tdb tevent ldb popt iniparser pythonPackages.subunit

    heimdal openldap cups pam avahi acl libaio fam ctdb ceph glusterfs

    libiconv gettext

    gnutls libgcrypt libgpgerror

    zlib ncurses libcap
  ];

  enableParallelBuilding = true;

  configureFlags = [
    # source3/wscript options
    "--with-static-modules=NONE"
    "--with-shared-modules=ALL"
    "--with-winbind"
  ] ++ (if heimdal != null then [ "--with-ads" ] else [ "--without-ads" ])
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
    ++ (if fam != null then [ "--with-fam" ] else [ "--without-fam" ])
    ++ (if ctdb != null then [ "--with-cluster-support" "--with-ctdb-dir=${ctdb}" ]
        else [ "--without-cluster-support" ])
    ++ (if ceph != null then [ "--with-libcephfs=${ceph}" ] else [ ])
    ++ (if glusterfs != null then [ "--enable-glusterfs" ] else [ "--disable-glusterfs" ]) ++ [
    # dynconfig/wscript options
    "--enable-fhs"
    "--sysconfdir=/etc"
    "--localstatedir=/var"

    # buildtools/wafsamba/wscript options
    "--bundled-libraries=${if heimdal != null then "NONE" else "com_err"}"
    "--private-libraries=NONE"
    "--builtin-libraries=replace"
  ] ++ (if libiconv != null then [ "--with-libiconv=${libiconv}" ] else [ ])
    ++ (if gettext != null then [ "--with-gettext=${gettext}" ] else [ "--without-gettext" ]) ++ [
    # source4/lib/tls/wscript options
  ] ++ (if gnutls != null && libgcrypt != null && libgpgerror != null
        then [ "--enable-gnutls" ] else [ "--disable-gnutls" ]) ++ [
    # wscript options
  ] ++ stdenv.lib.optional (heimdal == null) "--without-ad-dc";

  stripAllList = [ "bin" "sbin" ];

  meta = with stdenv.lib; {
    homepage = http://www.samba.org/;
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}
