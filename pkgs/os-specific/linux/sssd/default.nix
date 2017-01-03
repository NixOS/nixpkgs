{ stdenv, fetchurl, pkgs, lib, glibc, augeas, bind, c-ares,
  cyrus_sasl, ding-libs, libnl, libunistring, nss, samba, libnfsidmap, doxygen,
  python, python3, pam, popt, talloc, tdb, tevent, pkgconfig, ldb, openldap,
  pcre, kerberos, cifs_utils, glib, keyutils, dbus, fakeroot, libxslt, libxml2,
  docbook_xml_xslt, ldap, systemd, nspr, check, cmocka, uid_wrapper,
  nss_wrapper, docbook_xml_dtd_44, ncurses, Po4a, http-parser, jansson }:

let
  name = "sssd-${version}";
  version = "1.14.2";

  docbookFiles = "${pkgs.docbook_xml_xslt}/share/xml/docbook-xsl/catalog.xml:${pkgs.docbook_xml_dtd_44}/xml/dtd/docbook/catalog.xml";
in
stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = fetchurl {
    url = "https://fedorahosted.org/released/sssd/${name}.tar.gz";
    sha1 = "167b2216c536035175ff041d0449e0a874c68601";
  };

  preConfigure = ''
    export SGML_CATALOG_FILES="${docbookFiles}"
    export PYTHONPATH=${ldap}/lib/python2.7/site-packages
    export PATH=$PATH:${pkgs.openldap}/libexec
    export CPATH=${pkgs.libxml2.dev}/include/libxml2

    configureFlagsArray=(
      --prefix=$out
      --sysconfdir=/etc
      --localstatedir=/var
      --enable-pammoddir=$out/lib/security
      --with-os=fedora
      --with-pid-path=/run
      --with-python2-bindings
      --with-python3-bindings
      --with-syslog=journald
      --without-selinux
      --without-semanage
      --with-xml-catalog-path=''${SGML_CATALOG_FILES%%:*}
      --with-ldb-lib-dir=$out/modules/ldb
      --with-nscd=${glibc.bin}/sbin/nscd
    )
  '';

  enableParallelBuilding = true;
  buildInputs = [ augeas bind c-ares cyrus_sasl ding-libs libnl libunistring nss
                  samba libnfsidmap doxygen python python3 popt
                  talloc tdb tevent pkgconfig ldb pam openldap pcre kerberos
                  cifs_utils glib keyutils dbus fakeroot libxslt libxml2
                  ldap systemd nspr check cmocka uid_wrapper
                  nss_wrapper ncurses Po4a http-parser jansson ];

  makeFlags = [
    "SGML_CATALOG_FILES=${docbookFiles}"
  ];

  installFlags = [
     "sysconfdir=$(out)/etc"
     "localstatedir=$(out)/var"
     "pidpath=$(out)/run"
     "sss_statedir=$(out)/var/lib/sss"
     "logpath=$(out)/var/log/sssd"
     "pubconfpath=$(out)/var/lib/sss/pubconf"
     "dbpath=$(out)/var/lib/sss/db"
     "mcpath=$(out)/var/lib/sss/mc"
     "pipepath=$(out)/var/lib/sss/pipes"
     "gpocachepath=$(out)/var/lib/sss/gpo_cache"
     "secdbpath=$(out)/var/lib/sss/secrets"
     "initdir=$(out)/rc.d/init"
  ];

  postInstall = ''
    rm -rf "$out"/run
    rm -rf "$out"/rc.d
    rm -f "$out"/modules/ldb/memberof.la
    find "$out" -depth -type d -exec rmdir --ignore-fail-on-non-empty {} \;
  '';

  meta = with stdenv.lib; {
    description = "System Security Services Daemon";
    homepage = https://fedorahosted.org/sssd/;
    license = licenses.gpl3;
    maintainers = [ maintainers.e-user ];
  };
}
