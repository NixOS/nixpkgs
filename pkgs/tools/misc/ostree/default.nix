{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, gtk-doc, gobject-introspection, gnome3
, glib, systemd, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse, utillinuxMinimal, libselinux
, libarchive, libcap, bzip2, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42, python3
}:

let
  version = "2018.9";

  libglnx-src = fetchFromGitHub {
    owner = "GNOME";
    repo = "libglnx";
    rev = "470af8763ff7b99bec950a6ae0a957c1dcfc8edd";
    sha256 = "1fwik38i6w3r6pn4qkizradcqp1m83n7ljh9jg0y3p3kvrbfxh15";
  };

  bsdiff-src = fetchFromGitHub {
    owner = "mendsley";
    repo = "bsdiff";
    rev = "1edf9f656850c0c64dae260960fabd8249ea9c60";
    sha256 = "1h71d2h2d3anp4msvpaff445rnzdxii3id2yglqk7af9i43kdsn1";
  };
in stdenv.mkDerivation {
  name = "ostree-${version}";

  outputs = [ "out" "dev" "man" "installedTests" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "ostreedev";
    repo = "ostree";
    sha256 = "0a8gr4qqxcvz3fqv9w4dxy6iq0rq4kdzf08rzv8xg4gic3ldgyvj";
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

  prePatch = ''
    rmdir libglnx bsdiff
    cp --no-preserve=mode -r ${libglnx-src} libglnx
    cp --no-preserve=mode -r ${bsdiff-src} bsdiff
  '';


  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--with-systemdsystemgeneratordir=$(out)/lib/systemd/system-generators"
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=$(installedTests)/libexec/installed-tests/libostree"
    "installed_test_metadir=$(installedTests)/share/installed-tests/libostree"
  ];


  meta = with stdenv.lib; {
    description = "Git for operating system binaries";
    homepage = https://ostree.readthedocs.io/en/latest/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
