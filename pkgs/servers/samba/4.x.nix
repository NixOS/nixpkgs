{ lib, stdenv
, buildPackages
, fetchurl
, wafHook
, pkg-config
, bison
, flex
, perl
, libxslt
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
, systemd
, samba
, talloc
, jansson
, ldb
, libtasn1
, tdb
, tevent
, libxcrypt
, cmocka
, rpcsvc-proto
, bash
, python3Packages
, nixosTests
, libiconv

, enableLDAP ? false, openldap
, enablePrinting ? false, cups
, enableProfiling ? true
, enableMDNS ? false, avahi
, enableDomainController ? false, gpgme, lmdb
, enableRegedit ? true, ncurses
, enableCephFS ? false, ceph
, enableGlusterFS ? false, glusterfs, libuuid
, enableAcl ? (!stdenv.isDarwin), acl
, enableLibunwind ? (!stdenv.isDarwin), libunwind
, enablePam ? (!stdenv.isDarwin), pam
}:

with lib;

stdenv.mkDerivation rec {
  pname = "samba";
  version = "4.19.2";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${pname}-${version}.tar.gz";
    hash = "sha256-nmPwUF4cYx8dsLepNJpR6SXAJsoDrz/V2BIii7WX05M=";
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
    perl.pkgs.JSON
    libxslt
    docbook_xsl
    docbook_xml_dtd_45
    cmocka
    rpcsvc-proto
  ] ++ optionals stdenv.isLinux [
    buildPackages.stdenv.cc
  ] ++ optional (stdenv.buildPlatform != stdenv.hostPlatform) samba # asn1_compile/compile_et
    ++ optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  wafPath = "buildtools/bin/waf";

  buildInputs = [
    bash
    python3Packages.wrapPython
    python3Packages.python
    readline
    popt
    dbus
    jansson
    libbsd
    libarchive
    zlib
    gnutls
    libtasn1
    tdb
    libxcrypt
  ] ++ optionals stdenv.isLinux [ liburing systemd ]
    ++ optionals stdenv.isDarwin [ libiconv ]
    ++ optionals enableLDAP [ openldap.dev python3Packages.markdown ]
    ++ optionals (!enableLDAP && stdenv.isLinux) [ ldb talloc tevent ]
    ++ optional (enablePrinting && stdenv.isLinux) cups
    ++ optional enableMDNS avahi
    ++ optionals enableDomainController [ gpgme lmdb python3Packages.dnspython ]
    ++ optional enableRegedit ncurses
    ++ optional (enableCephFS && stdenv.isLinux) (lib.getDev ceph)
    ++ optionals (enableGlusterFS && stdenv.isLinux) [ glusterfs libuuid ]
    ++ optional enableAcl acl
    ++ optional enableLibunwind libunwind
    ++ optional enablePam pam;

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions

    # Fix the XML Catalog Paths
    sed -i "s,\(XML_CATALOG_FILES=\"\),\1$XML_CATALOG_FILES ,g" buildtools/wafsamba/wafsamba.py

    patchShebangs ./buildtools/bin
  '';

  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
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
  ] ++ optionals (!enableLDAP && stdenv.isLinux) [
    "--bundled-libraries=!ldb,!pyldb-util!talloc,!pytalloc-util,!tevent,!tdb,!pytdb"
  ] ++ optional enableLibunwind "--with-libunwind"
    ++ optional enableProfiling "--with-profiling-data"
    ++ optional (!enableAcl) "--without-acl-support"
    ++ optional (!enablePam) "--without-pam"
    ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--bundled-libraries=!asn1_compile,!compile_et"
  ] ++ optionals stdenv.isAarch32 [
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

  # Save asn1_compile and compile_et so they are available to run on the build
  # platform when cross-compiling
  postInstall = optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p "$dev/bin"
    cp bin/asn1_compile bin/compile_et "$dev/bin"
  '';

  # Some libraries don't have /lib/samba in RPATH but need it.
  # Use find -type f -executable -exec echo {} \; -exec sh -c 'ldd {} | grep "not found"' \;
  # Looks like a bug in installer scripts.
  postFixup = ''
    export SAMBA_LIBS="$(find $out -type f -regex '.*\${stdenv.hostPlatform.extensions.sharedLibrary}\(\..*\)?' -exec dirname {} \; | sort | uniq)"
    read -r -d "" SCRIPT << EOF || true
    [ -z "\$SAMBA_LIBS" ] && exit 1;
    BIN='{}';
  '' + lib.optionalString stdenv.isLinux ''
    OLD_LIBS="\$(patchelf --print-rpath "\$BIN" 2>/dev/null | tr ':' '\n')";
    ALL_LIBS="\$(echo -e "\$SAMBA_LIBS\n\$OLD_LIBS" | sort | uniq | tr '\n' ':')";
    patchelf --set-rpath "\$ALL_LIBS" "\$BIN" 2>/dev/null || exit $?;
    patchelf --shrink-rpath "\$BIN";
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -id \$BIN \$BIN
    for old_rpath in \$(otool -L \$BIN | grep /private/tmp/ | awk '{print \$1}'); do
      new_rpath=\$(find \$SAMBA_LIBS -name \$(basename \$old_rpath) | head -n 1)
      install_name_tool -change \$old_rpath \$new_rpath \$BIN
    done
  '' + ''
    EOF
    find $out -type f -regex '.*\${stdenv.hostPlatform.extensions.sharedLibrary}\(\..*\)?' -exec $SHELL -c "$SCRIPT" \;
    find $out/bin -type f -exec $SHELL -c "$SCRIPT" \;

    # Fix PYTHONPATH for some tools
    wrapPythonPrograms

    # Samba does its own shebang patching, but uses build Python
    find $out/bin -type f -executable | while read file; do
      isScript "$file" || continue
      sed -i 's^${lib.getBin buildPackages.python3Packages.python}/bin^${lib.getBin python3Packages.python}/bin^' "$file"
    done
  '';

  disallowedReferences =
    lib.optionals (buildPackages.python3Packages.python != python3Packages.python)
      [ buildPackages.python3Packages.python ];

  passthru = {
    tests.samba = nixosTests.samba;
  };

  meta = with lib; {
    homepage = "https://www.samba.org";
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    platforms = platforms.unix;
    broken = enableGlusterFS;
    maintainers = with maintainers; [ aneeshusa ];
  };
}
