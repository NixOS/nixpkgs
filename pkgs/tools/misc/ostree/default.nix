{ stdenv
, fetchurl
, fetchpatch
, substituteAll
, pkgconfig
, gtk-doc
, gobject-introspection
, gjs
, nixosTests
, glib
, systemd
, xz
, e2fsprogs
, libsoup
, gpgme
, which
, makeWrapper
, autoconf
, automake
, libtool
, fuse
, utillinuxMinimal
, libselinux
, libarchive
, libcap
, bzip2
, yacc
, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, python3
}:

let
  testPython = (python3.withPackages (p: with p; [
    pyyaml
  ]));
in stdenv.mkDerivation rec {
  pname = "ostree";
  version = "2019.6";

  outputs = [ "out" "dev" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${version}/libostree-${version}.tar.xz";
    sha256 = "1bhrfbjna3rnymijxagzkdq2zl74g71s2xmimihjhvcw2zybi0jl";
  };

  patches = [
    # Tests access the helper using relative path
    # https://github.com/ostreedev/ostree/issues/1593
    # Patch from https://github.com/ostreedev/ostree/pull/1633
    ./01-Drop-ostree-trivial-httpd-CLI-move-to-tests-director.patch

    # Fix tests running in Catalan instead of C locale.
    (fetchpatch {
      url = "https://github.com/ostreedev/ostree/commit/5135a1e58ade2bfafc8c1fda359540eafd72531e.patch";
      sha256 = "1crzaagw1zzx8v6rsnxb9jnc3ij9hlpvdl91w3skqdm28adx7yx8";
    })

    # Workarounds for https://github.com/ostreedev/ostree/issues/1592
    ./fix-1592.patch

    # Hard-code paths in tests
    (substituteAll {
      src = ./fix-test-paths.patch;
      python3 = testPython.interpreter;
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkgconfig
    gtk-doc
    gobject-introspection
    which
    makeWrapper
    yacc
    libxslt
    docbook_xsl
    docbook_xml_dtd_42
  ];

  buildInputs = [
    glib
    systemd
    e2fsprogs
    libsoup
    gpgme
    fuse
    libselinux
    libcap
    libarchive
    bzip2
    xz
    utillinuxMinimal # for libmount

    # for installed tests
    testPython
    gjs
  ];

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdsystemgeneratordir=${placeholder "out"}/lib/systemd/system-generators"
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/libostree"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/libostree"
  ];

  postFixup = ''
    for test in $installedTests/libexec/installed-tests/libostree/*.js; do
      wrapProgram "$test" --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0"
    done
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.ostree;
    };
  };

  meta = with stdenv.lib; {
    description = "Git for operating system binaries";
    homepage = "https://ostree.readthedocs.io/en/latest/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
