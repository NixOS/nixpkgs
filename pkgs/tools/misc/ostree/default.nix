{ stdenv, fetchurl, fetchpatch, pkgconfig, gtk-doc, gobject-introspection, gnome3
, glib, systemd, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse, utillinuxMinimal, libselinux
, libarchive, libcap, bzip2, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42, python3
}:

stdenv.mkDerivation rec {
  pname = "ostree";
  version = "2019.2";

  outputs = [ "out" "dev" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${version}/libostree-${version}.tar.xz";
    sha256 = "0nbbrz3p4ms6vpl272q6fimqvizryw2a8mnfqcn69xf03sz5204y";
  };

  patches = [
    # Workarounds for https://github.com/ostreedev/ostree/issues/1592
    ./fix-1592.patch
    # Disable test-gpg-verify-result.test,
    # https://github.com/ostreedev/ostree/issues/1634
    ./disable-test-gpg-verify-result.patch
    # Tests access the helper using relative path
    # https://github.com/ostreedev/ostree/issues/1593
    ./01-Drop-ostree-trivial-httpd-CLI-move-to-tests-director.patch
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
