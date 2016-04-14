{ stdenv, fetchurl, pkgs, augeas, bind, c-ares, cyrus_sasl, ding-libs, libnl,
  libunistring, nss, samba, libnfsidmap, doxygen, python, python3,
  pam, popt, talloc, tdb, tevent, pkgconfig, ldb, openldap, pcre, kerberos,
  cifs_utils, glib, keyutils, dbus, fakeroot, libxslt, libxml2,
  docbook_xml_xslt, ldap, systemd, nspr, check, cmocka,
  uid_wrapper, nss_wrapper, docbook_xml_dtd_44, ncurses, Po4a }:

let
  name = "sssd";
  version = "1.13.3";
in stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = fetchurl {
    url = "https://fedorahosted.org/released/${name}/${name}-${version}.tar.gz";
    sha256 = "3fd8fe8e6ee9f50b33eecd1bcccfaa44791f30d4e5f3113ba91457ba5f411f85";
  };

  preConfigure = ''
    cd "$NIX_BUILD_TOP/$name-$version"
    for f in "''${source[@]}"; do
      if [[ $f == *.patch ]]; then
        patch -p1 < "$NIX_BUILD_TOP/$name-$version/$f"
      fi
    done

    export SGML_CATALOG_FILES="${pkgs.docbook_xml_xslt}/share/xml/docbook-xsl/catalog.xml:${pkgs.docbook_xml_dtd_44}/xml/dtd/docbook/catalog.xml"
    export PYTHONPATH=${ldap}/lib/python2.7/site-packages
    export PATH=$PATH:${pkgs.openldap}/libexec
    export CPATH=${pkgs.libxml2}/include/libxml2

    configureFlags="--prefix=$out --sysconfdir=/etc --localstatedir=/var --enable-pammoddir=$out/lib/security --with-os=fedora --with-pid-path=/run --with-python2-bindings --with-python3-bindings --with-syslog=journald --without-selinux --without-semanage --with-xml-catalog-path=''${SGML_CATALOG_FILES%%:*} --with-ldb-lib-dir=$out/modules/ldb"
  '';

  enableParallelBuilding = true;
  buildInputs = [ augeas bind c-ares cyrus_sasl ding-libs libnl libunistring nss
                  samba libnfsidmap doxygen python python3 popt
                  talloc tdb tevent pkgconfig ldb pam openldap pcre kerberos
                  cifs_utils glib keyutils dbus fakeroot libxslt libxml2
                  ldap systemd nspr check cmocka uid_wrapper
                  nss_wrapper ncurses Po4a ];

  buildPhase = ''
    cd "$NIX_BUILD_TOP/$name-$version"
    substituteInPlace config.h --replace "<HAVE_KRB5_SET_TRACE_CALLBACK>" ""
    make SGML_CATALOG_FILES="$SGML_CATALOG_FILES"
  '';

  installPhase = ''
    cd "$NIX_BUILD_TOP/$name-$version"
    make SGML_CATALOG_FILES="$SGML_CATALOG_FILES" sysconfdir="$out/etc" localstatedir="$out/var" pidpath="$out/run" sss_statedir="$out/var/lib/sss" logpath="$out/var/log/sssd" pubconfpath="$out/var/lib/sss/pubconf" dbpath="$out/var/lib/sss/db" mcpath="$out/var/lib/sss/mc" pipepath="$out/var/lib/sss/pipes" gpocachepath="$out/var/lib/sss/gpo_cache" initdir="$out/rc.d/init.d" install
    rm -rf "$out"/run
    rm -rf "$out"/rc.d
    rm -f "$out"/modules/ldb/memberof.la
    find "$out" -depth -type d -exec rmdir --ignore-fail-on-non-empty {} \;
  '';

  meta = {
    inherit version;
    description = "System Security Services Daemon";
    homepage = https://fedorahosted.org/sssd/;
    license = stdenv.lib.licenses.gpl3;
  };
}
