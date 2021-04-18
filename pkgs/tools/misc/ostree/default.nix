{ stdenv
, fetchurl
, fetchpatch
, substituteAll
, pkg-config
, gtk-doc
, gobject-introspection
, gjs
, nixosTests
, glib
, systemd
, xz
, e2fsprogs
, libsoup
, glib-networking
, wrapGAppsHook
, gpgme
, which
, makeWrapper
, autoconf
, automake
, libtool
, fuse
, utillinuxMinimal
, libselinux
, libsodium
, libarchive
, libcap
, bzip2
, yacc
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, openssl
, python3
}:

let
  testPython = (python3.withPackages (p: with p; [
    pyyaml
  ]));
in stdenv.mkDerivation rec {
  pname = "ostree";
  version = "2020.5";

  outputs = [ "out" "dev" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${version}/libostree-${version}.tar.xz";
    sha256 = "1k92177hjalbdpmg45ymwwrni68vh9rs5x9zvy5fzl9lng12fgpb";
  };

  patches = [
    # Tests access the helper using relative path
    # https://github.com/ostreedev/ostree/issues/1593
    # Patch from https://github.com/ostreedev/ostree/pull/1633
    ./01-Drop-ostree-trivial-httpd-CLI-move-to-tests-director.patch

    # Workarounds for https://github.com/ostreedev/ostree/issues/1592
    ./fix-1592.patch

    # Hard-code paths in tests
    (substituteAll {
      src = ./fix-test-paths.patch;
      python3 = testPython.interpreter;
      openssl = "${openssl}/bin/openssl";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    gtk-doc
    gobject-introspection
    which
    makeWrapper
    yacc
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    systemd
    e2fsprogs
    libsoup
    glib-networking
    gpgme
    fuse
    libselinux
    libsodium
    libcap
    libarchive
    bzip2
    xz
    utillinuxMinimal # for libmount

    # for installed tests
    testPython
    gjs
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdsystemgeneratordir=${placeholder "out"}/lib/systemd/system-generators"
    "--enable-installed-tests"
    "--with-ed25519-libsodium"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/libostree"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/libostree"
  ];

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup = let
    typelibPath = stdenv.lib.makeSearchPath "/lib/girepository-1.0" [
      (placeholder "out")
      gobject-introspection
    ];
  in ''
    for test in $installedTests/libexec/installed-tests/libostree/*.js; do
      wrapProgram "$test" --prefix GI_TYPELIB_PATH : "${typelibPath}"
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
