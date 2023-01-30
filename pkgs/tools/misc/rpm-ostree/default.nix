{ lib, stdenv
, fetchurl
, ostree
, rpm
, which
, autoconf
, automake
, libtool
, pkg-config
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
, python3
, json_c
, zchunk
, libmodulemd
, util-linux
, sqlite
, cppunit
}:

stdenv.mkDerivation rec {
  pname = "rpm-ostree";
  version = "2023.1";

  outputs = [ "out" "dev" "man" "devdoc" ];

  src = fetchurl {
    url = "https://github.com/coreos/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    hash = "sha256-JNLp1IHbIRpe3Au2iUsx7x065rirQlzT9bg7CoqHCyg=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
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

    # libdnf # vendored unstable branch
    # required by vendored libdnf
    json_c
    zchunk
    libmodulemd
    util-linux # for smartcols.pc
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

  # https://github.com/NixOS/nixpkgs/issues/201254
  NIX_LDFLAGS = lib.optionalString (stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU) "-lgcc";

  meta = with lib; {
    description = "A hybrid image/package system. It uses OSTree as an image format, and uses RPM as a component model";
    homepage = "https://coreos.github.io/rpm-ostree/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.linux;
  };
}
