{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  substituteAll,
  pkg-config,
  gtk-doc,
  gobject-introspection,
  gjs,
  nixosTests,
  pkgsCross,
  curl,
  glib,
  systemd,
  xz,
  e2fsprogs,
  libsoup,
  glib-networking,
  wrapGAppsNoGuiHook,
  gpgme,
  which,
  makeWrapper,
  autoconf,
  automake,
  libtool,
  fuse3,
  util-linuxMinimal,
  libselinux,
  libsodium,
  libarchive,
  libcap,
  bzip2,
  bison,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  openssl,
  python3,
}:

let
  testPython = python3.withPackages (
    p: with p; [
      pyyaml
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "ostree";
  version = "2024.4";

  outputs = [
    "out"
    "dev"
    "man"
    "installedTests"
  ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${version}/libostree-${version}.tar.xz";
    sha256 = "sha256-Y8kZCCEzOsc3Pg2SPkwnZrJevc/fTvtEy1koxlidn8s=";
  };

  patches = lib.optionals stdenv.hostPlatform.isMusl [
    # > I guess my inclination here is to recommend that musl users
    # > carry a downstream patch to revert the commits in #3175 until
    # > such time as they can update to the new musl.
    # https://github.com/ostreedev/ostree/issues/3200#issuecomment-1974819192
    (fetchpatch {
      name = "revert-statx.diff";
      url = "https://github.com/ostreedev/ostree/commit/f46cc0cd85b564e40e03c7438a41c8e57f6b836c.diff";
      excludes = [ "ci/*" ];
      revert = true;
      hash = "sha256-LsXbRYh4hfjNdt1S384IPlSvtC5f2rgSTZEkIIBkT0g=";
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
    bison
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    curl
    glib
    systemd
    e2fsprogs
    libsoup
    glib-networking
    gpgme
    fuse3
    libselinux
    libsodium
    libcap
    libarchive
    bzip2
    xz
    util-linuxMinimal # for libmount

    # for installed tests
    testPython
    gjs
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-curl"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdsystemgeneratordir=${placeholder "out"}/lib/systemd/system-generators"
    "--enable-installed-tests"
    "--with-ed25519-libsodium"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/libostree"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/libostree"
    # Setting this flag was required as workaround for a clang bug, but seems not relevant anymore.
    # https://github.com/ostreedev/ostree/commit/fd8795f3874d623db7a82bec56904648fe2c1eb7
    # See also Makefile-libostree.am
    "INTROSPECTION_SCANNER_ENV="
  ];

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup =
    let
      typelibPath = lib.makeSearchPath "/lib/girepository-1.0" [
        (placeholder "out")
        gobject-introspection
      ];
    in
    ''
      for test in $installedTests/libexec/installed-tests/libostree/*.js; do
        wrapProgram "$test" --prefix GI_TYPELIB_PATH : "${typelibPath}"
      done
    '';

  passthru = {
    tests = {
      musl = pkgsCross.musl64.ostree;
      installedTests = nixosTests.installed-tests.ostree;
    };
  };

  meta = with lib; {
    description = "Git for operating system binaries";
    homepage = "https://ostreedev.github.io/ostree/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
