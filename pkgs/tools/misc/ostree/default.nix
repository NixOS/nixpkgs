{ stdenv, fetchurl, fetchpatch, pkgconfig, gtk-doc, gobject-introspection, gnome3
, glib, systemd, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse, utillinuxMinimal, libselinux
, libarchive, libcap, bzip2, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42, python3
}:

stdenv.mkDerivation rec {
  pname = "ostree";
  version = "2019.1";

  outputs = [ "out" "dev" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${version}/libostree-${version}.tar.xz";
    sha256 = "08y7nsxl305dnlfak4kyj88lld848y4kg6bvjqngcxaqqvkk9xqm";
  };

  patches = [
    # Workarounds for https://github.com/ostreedev/ostree/issues/1592
    ./fix-1592.patch
    # Disable test-gpg-verify-result.test,
    # https://github.com/ostreedev/ostree/issues/1634
    ./disable-test-gpg-verify-result.patch
    # Tests access the helper using relative path
    # https://github.com/ostreedev/ostree/issues/1593
    (fetchpatch {
      url = https://github.com/ostreedev/ostree/pull/1633.patch;
      sha256 = "07xiw1dr7j4yw3w92qhw37f9crlglibflcqj2kf0v5gfrl9i6g4j";
    })
  ];

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig gtk-doc gobject-introspection which yacc
    libxslt docbook_xsl docbook_xml_dtd_42
  ];

  buildInputs = [
    glib systemd e2fsprogs libsoup gpgme fuse libselinux libcap
    libarchive bzip2 xz
    utillinuxMinimal # for libmount
    (python3.withPackages (p: with p; [ pyyaml ])) gnome3.gjs # for tests
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

  meta = with stdenv.lib; {
    description = "Git for operating system binaries";
    homepage = https://ostree.readthedocs.io/en/latest/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
