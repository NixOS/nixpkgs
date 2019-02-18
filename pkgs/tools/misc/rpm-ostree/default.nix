{ stdenv, fetchurl, ostree, rpm, which, autoconf, automake, libtool, pkgconfig, cargo, rustc,
  gobject-introspection, gtk-doc, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_43, gperf, cmake,
  libcap, glib, systemd, json-glib, libarchive, libsolv, librepo, polkit,
  bubblewrap, pcre, check, python }:

stdenv.mkDerivation rec {
  pname = "rpm-ostree";
  version = "2019.1";

  src = fetchurl {
    url = "https://github.com/projectatomic/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "14qk8mq5yc67j3wl3fa9xnhh8ii8x5qdiavf7ybw7mp4ma4lwa8k";
  };

  patches = [
    # gobject-introspection requires curl in cflags
    # https://github.com/NixOS/nixpkgs/pull/50953#issuecomment-449777169
    # https://github.com/NixOS/nixpkgs/pull/50953#issuecomment-452177080
    ./fix-introspection-build.patch
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
