{ lib, stdenv, fetchFromGitHub, autoreconfHook, makeWrapper, glibc, augeas, dnsutils, c-ares, curl,
  cyrus_sasl, ding-libs, libnl, libunistring, nss, samba, nfs-utils, doxygen,
  python3, pam, popt, talloc, tdb, tevent, pkg-config, ldb, openldap,
  pcre2, libkrb5, cifs-utils, glib, keyutils, dbus, fakeroot, libxslt, libxml2,
  libuuid, systemd, nspr, check, cmocka, uid_wrapper, p11-kit,
  nss_wrapper, ncurses, Po4a, http-parser, jansson, jose,
  docbook_xsl, docbook_xml_dtd_44,
  nixosTests,
  withSudo ? false }:

let
  docbookFiles = "${docbook_xsl}/share/xml/docbook-xsl/catalog.xml:${docbook_xml_dtd_44}/xml/dtd/docbook/catalog.xml";
in
stdenv.mkDerivation rec {
  pname = "sssd";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "SSSD";
    repo = pname;
    rev = version;
    sha256 = "sha256-TbeofUQAQNM/Nxzgl8GP2+Y4iR7bVXm4dQaPkYMSdqc=";
  };

  postPatch = ''
    patchShebangs ./sbus_generate.sh.in
  '';

  # Something is looking for <libxml/foo.h> instead of <libxml2/libxml/foo.h>
  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  preConfigure = ''
    export SGML_CATALOG_FILES="${docbookFiles}"
    export PYTHONPATH=$(find ${python3.pkgs.python-ldap} -type d -name site-packages)
    export PATH=$PATH:${openldap}/libexec

    configureFlagsArray=(
      --prefix=$out
      --sysconfdir=/etc
      --localstatedir=/var
      --enable-pammoddir=$out/lib/security
      --with-os=fedora
      --with-pid-path=/run
      --with-python3-bindings
      --with-syslog=journald
      --without-selinux
      --without-semanage
      --with-xml-catalog-path=''${SGML_CATALOG_FILES%%:*}
      --with-ldb-lib-dir=$out/modules/ldb
      --with-nscd=${glibc.bin}/sbin/nscd
    )
  '' + lib.optionalString withSudo ''
    configureFlagsArray+=("--with-sudo")
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook makeWrapper pkg-config doxygen ];
  buildInputs = [ augeas dnsutils c-ares curl cyrus_sasl ding-libs libnl libunistring nss
                  samba nfs-utils p11-kit python3 popt
                  talloc tdb tevent ldb pam openldap pcre2 libkrb5
                  cifs-utils glib keyutils dbus fakeroot libxslt libxml2
                  libuuid python3.pkgs.python-ldap systemd nspr check cmocka uid_wrapper
                  nss_wrapper ncurses Po4a http-parser jansson jose ];

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
  postFixup = ''
    for f in $out/bin/sss{ctl,_cache,_debuglevel,_override,_seed}; do
      wrapProgram $f --prefix LDB_MODULES_PATH : $out/modules/ldb
    done
  '';

  passthru.tests = { inherit (nixosTests) sssd sssd-ldap; };

  meta = with lib; {
    description = "System Security Services Daemon";
    homepage = "https://sssd.io/";
    changelog = "https://sssd.io/release-notes/sssd-${version}.html";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ illustris ];
  };
}
