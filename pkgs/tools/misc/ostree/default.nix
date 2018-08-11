{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, gtk-doc, gobjectIntrospection, gnome3
, glib, systemd, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse, utillinuxMinimal, libselinux
, libarchive, libcap, bzip2, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42, python3
}:

let
  version = "2018.6";

  libglnx-src = fetchFromGitHub {
    owner = "GNOME";
    repo = "libglnx";
    rev = "e1a78cf2f5351d5394ccfb79f3f5a7b4917f73f3";
    sha256 = "10kzyjbrmr98i65hlz8jc1v5bijyqwwfp6qqjbd5g3y0n520iaxc";
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
    sha256 = "0kk04pznk6m6fqdz609m2zcnkalcw9q8fsx8wm42k6dhf6cw7l3g";
  };

  patches = [
    # Tests access the helper using relative path
    # https://github.com/ostreedev/ostree/issues/1593
    (fetchpatch {
      url = https://github.com/ostreedev/ostree/pull/1633.patch;
      sha256 = "07xiw1dr7j4yw3w92qhw37f9crlglibflcqj2kf0v5gfrl9i6g4j";
    })
  ];

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig gtk-doc gobjectIntrospection which yacc
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
