{ stdenv
, fetchurl
, ostree
, rpm
, which
, autoconf
, automake
, libtool
, pkgconfig
, cargo
, rustc
, gobject-introspection
, gtk-doc
, libxml2
, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, gperf
, cmake
, libcap
, glib
, systemd
, json-glib
, libarchive
, libsolv
, librepo
, polkit
, bubblewrap
, pcre
, check
, python
, json_c
, zchunk
, libmodulemd_1
, utillinux
, sqlite
, cppunit
}:

stdenv.mkDerivation rec {
  pname = "rpm-ostree";
  version = "2020.1";

  outputs = [ "out" "dev" "man" "devdoc" ];

  src = fetchurl {
    url = "https://github.com/coreos/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "1xgfppq4fqqvg3cs327bckjpiz6rrn3bbbhg3q5p4j2bzsq89xiz";
  };

  nativeBuildInputs = [
    pkgconfig
    which
    autoconf
    automake
    libtool
    cmake
    gperf
    cargo
    rustc
    gobject-introspection
    gtk-doc
    libxml2
    libxslt
    docbook_xsl
    docbook_xml_dtd_42
    docbook_xml_dtd_43
  ];

  buildInputs = [
    libcap
    ostree
    rpm
    glib
    systemd
    polkit
    bubblewrap
    json-glib
    libarchive
    libsolv
    librepo
    pcre
    check
    python
    # libdnf
    json_c
    zchunk
    libmodulemd_1
    utillinux
    sqlite
    cppunit
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
    homepage = "https://rpm-ostree.readthedocs.io/en/latest/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.linux;
  };
}
