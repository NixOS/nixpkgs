{ stdenv, fetchurl, ostree, rpm, which, autoconf, automake, libtool, pkgconfig, cargo, rustc,
  gobject-introspection, gtk-doc, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_43, gperf, cmake,
  libcap, glib, systemd, json-glib, libarchive, libsolv, librepo, polkit,
  bubblewrap, pcre, check, python, json_c, libmodulemd_1, utillinux, sqlite, cppunit, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "rpm-ostree";
  version = "2019.5";

  src = fetchurl {
    url = "https://github.com/projectatomic/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0innbrjj086mslbf55bcvs9a3rv9hg1y2nhzxdjy3nhpqxqlzdnn";
  };

  patches = [
    # gobject-introspection requires curl in cflags
    # https://github.com/NixOS/nixpkgs/pull/50953#issuecomment-449777169
    # https://github.com/NixOS/nixpkgs/pull/50953#issuecomment-452177080
    ./fix-introspection-build.patch

    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://github.com/coreos/rpm-ostree/commit/60053d0d3d2279d120ae7007c6048e499d2c4d14.patch";
      sha256 = "0ig21zip09iy2da7ksg87jykaj3q8jyzh8r7yrpzyql85qxiwm0m";
    })
  ];

  outputs = [ "out" "dev" "man" "devdoc" ];
  nativeBuildInputs = [
    pkgconfig which autoconf automake libtool cmake gperf cargo rustc
    gobject-introspection gtk-doc libxml2 libxslt docbook_xsl docbook_xml_dtd_42 docbook_xml_dtd_43
  ];
  buildInputs = [
    libcap ostree rpm glib systemd polkit bubblewrap
    json-glib libarchive libsolv librepo
    pcre check python
     # libdnf
    json_c libmodulemd_1 utillinux sqlite cppunit
  ];

  configureFlags = [
    "--enable-gtk-doc"
    "--with-bubblewrap=${bubblewrap}/bin/bwrap"
  ];

  dontUseCmakeConfigure = true;

  prePatch = ''
    # According to #cmake on freenode, libdnf should bundle the FindLibSolv.cmake module
    cp ${libsolv}/share/cmake/Modules/FindLibSolv.cmake libdnf/cmake/modules/

    # Let's not hardcode the rpm-gpg path...
    substituteInPlace libdnf/libdnf/dnf-keyring.cpp \
      --replace '"/etc/pki/rpm-gpg"' 'getenv("LIBDNF_RPM_GPG_PATH_OVERRIDE") ? getenv("LIBDNF_RPM_GPG_PATH_OVERRIDE") : "/etc/pki/rpm-gpg"'
  '';

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A hybrid image/package system. It uses OSTree as an image format, and uses RPM as a component model";
    homepage = https://rpm-ostree.readthedocs.io/en/latest/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.linux;
  };
}
