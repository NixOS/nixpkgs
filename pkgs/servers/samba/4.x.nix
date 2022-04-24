{ lib, stdenv
, buildPackages
, fetchurl
, wafHook
, pkg-config
, bison
, flex
, perl
, libxslt
, heimdal
, docbook_xsl
, fixDarwinDylibNames
, docbook_xml_dtd_45
, readline
, popt
, dbus
, libbsd
, libarchive
, zlib
, liburing
, gnutls
, libunwind
, systemd
, jansson
, libtasn1
, tdb
, cmocka
, rpcsvc-proto
, python3Packages
, nixosTests

, enableLDAP ? false, openldap
, enablePrinting ? false, cups
, enableProfiling ? true
, enableMDNS ? false, avahi
, enableDomainController ? false, gpgme, lmdb
, enableRegedit ? true, ncurses
, enableCephFS ? false, ceph
, enableGlusterFS ? false, glusterfs, libuuid
, enableAcl ? (!stdenv.isDarwin), acl
, enablePam ? (!stdenv.isDarwin), pam
}:

with lib;

stdenv.mkDerivation rec {
  pname = "samba";
  version = "4.15.5";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${pname}-${version}.tar.gz";
    sha256 = "sha256-aRFeM4MZN7pRUb4CR5QxR3Za7OZYunQ/RHQWcq1o0X8=";
  };

  outputs = [ "out" "dev" "man" ];

  patches = [
    ./4.x-no-persistent-install.patch
    ./patch-source3__libads__kerberos_keytab.c.patch
    ./4.x-no-persistent-install-dynconfig.patch
    ./4.x-fix-makeflags-parsing.patch
    ./build-find-pre-built-heimdal-build-tools-in-case-of-.patch
  ];

  nativeBuildInputs = [
    python3Packages.python
    wafHook
    pkg-config
    bison
    flex
    perl
    perl.pkgs.ParseYapp
    libxslt
    buildPackages.stdenv.cc
    heimdal
    docbook_xsl
    docbook_xml_dtd_45
    cmocka
    rpcsvc-proto
  ] ++ optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    python3Packages.python
    python3Packages.wrapPython
    readline
    popt
    dbus
    jansson
    libbsd
    libarchive
    zlib
    libunwind
    gnutls
    libtasn1
    tdb
  ] ++ optionals stdenv.isLinux [ liburing systemd ]
    ++ optionals enableLDAP [ openldap.dev python3Packages.markdown ]
    ++ optional (enablePrinting && stdenv.isLinux) cups
    ++ optional enableMDNS avahi
    ++ optionals enableDomainController [ gpgme lmdb python3Packages.dnspython ]
    ++ optional enableRegedit ncurses
    ++ optional (enableCephFS && stdenv.isLinux) (lib.getDev ceph)
    ++ optionals (enableGlusterFS && stdenv.isLinux) [ glusterfs libuuid ]
    ++ optional enableAcl acl
    ++ optional enablePam pam;

  wafPath = "buildtools/bin/waf";

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions

    # Fix the XML Catalog Paths
    sed -i "s,\(XML_CATALOG_FILES=\"\),\1$XML_CATALOG_FILES ,g" buildtools/wafsamba/wafsamba.py

    patchShebangs ./buildtools/bin
  '';

  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
  '';

  wafConfigureFlags = [
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
    ++ optional (!enablePam) "--without-pam"
    ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--bundled-libraries=!asn1_compile,!compile_et"
  ] ++ optional stdenv.isAarch32 [
    # https://bugs.gentoo.org/683148
    "--jobs 1"
  ];

  # python-config from build Python gives incorrect values when cross-compiling.
  # If python-config is not found, the build falls back to using the sysconfig
  # module, which works correctly in all cases.
  PYTHON_CONFIG = "/invalid";

  pythonPath = [ python3Packages.dnspython tdb ];

  preBuild = ''
    export MAKEFLAGS="-j $NIX_BUILD_CORES"
  '';

  # Some libraries don't have /lib/samba in RPATH but need it.
  # Use find -type f -executable -exec echo {} \; -exec sh -c 'ldd {} | grep "not found"' \;
  # Looks like a bug in installer scripts.
  postFixup = ''
    export SAMBA_LIBS="$(find $out -type f -regex '.*\.so\(\..*\)?' -exec dirname {} \; | sort | uniq)"
    read -r -d "" SCRIPT << EOF || true
    [ -z "\$SAMBA_LIBS" ] && exit 1;
    BIN='{}';
    OLD_LIBS="\$(patchelf --print-rpath "\$BIN" 2>/dev/null | tr ':' '\n')";
    ALL_LIBS="\$(echo -e "\$SAMBA_LIBS\n\$OLD_LIBS" | sort | uniq | tr '\n' ':')";
    patchelf --set-rpath "\$ALL_LIBS" "\$BIN" 2>/dev/null || exit $?;
    patchelf --shrink-rpath "\$BIN";
    EOF
    find $out -type f -regex '.*\.so\(\..*\)?' -exec $SHELL -c "$SCRIPT" \;

    # Samba does its own shebang patching, but uses build Python
    find "$out/bin" -type f -executable -exec \
      sed -i '1 s^#!${python3Packages.python.pythonForBuild}/bin/python.*^#!${python3Packages.python.interpreter}^' {} \;

    # Fix PYTHONPATH for some tools
    wrapPythonPrograms
  '';

  passthru = {
    tests.samba = nixosTests.samba;
  };

  meta = with lib; {
    homepage = "https://www.samba.org";
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    platforms = platforms.unix;
    # N.B. enableGlusterFS does not build
    broken = stdenv.isDarwin || enableGlusterFS;
    maintainers = with maintainers; [ aneeshusa ];
  };
}
