{ stdenv, fetchpatch, fetchFromGitHub, ostree, rpm, which, autoconf, automake, libtool, pkgconfig,
  gobject-introspection, gtk-doc, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_42, gperf, cmake,
  libcap, glib, systemd, json-glib, libarchive, libsolv, librepo, polkit,
  bubblewrap, pcre, check, python }:

let
  libglnx-src = fetchFromGitHub {
    owner = "GNOME";
    repo = "libglnx";
    rev = "97b5c08d2f93dc93ba296a84bbd2a5ab9bd8fc97";
    sha256 = "0cz4x63f6ys7dln54g6mrr7hksvqwz78wdc8qb7zr1h2cp1azcvs";
  };

  libdnf-src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "libdnf";
    rev = "b3fcc53f6f3baf4f51f836f5e1eb54eb82d5df49";
    sha256 = "15nl9x4blyc9922rvz7iq56yy8hxhpsf31cs3ag7aypqpfx3czci";
  };

  version = "2018.5";
in stdenv.mkDerivation {
  name = "rpm-ostree-${version}";

  outputs = [ "out" "dev" "man" "devdoc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "projectatomic";
    repo = "rpm-ostree";
    sha256 = "0y37hr8mmrsww4ka2hlqmz7wp57ibzhah4j87yg8q8dks5hxcbsx";
  };

  nativeBuildInputs = [
    pkgconfig which autoconf automake libtool cmake gperf
    gobject-introspection gtk-doc libxml2 libxslt docbook_xsl docbook_xml_dtd_42
  ];
  buildInputs = [
    libcap ostree rpm glib systemd polkit bubblewrap
    json-glib libarchive libsolv librepo
    pcre check python
  ];

  patches = [
    # Use gdbus-codegen from PATH
    (fetchpatch {
      url = https://github.com/projectatomic/rpm-ostree/commit/315406d8cd0937e786723986e88d376c88806c60.patch;
      sha256 = "073yfa62515kyf58s0sz56w0a40062lh761y2y4assqipybwxbvp";
    })
  ];

  configureFlags = [
    "--enable-gtk-doc"
    "--with-bubblewrap=${bubblewrap}/bin/bwrap"
  ];

  dontUseCmakeConfigure = true;

  prePatch = ''
    rmdir libglnx libdnf
    cp --no-preserve=mode -r ${libglnx-src} libglnx
    cp --no-preserve=mode -r ${libdnf-src} libdnf

    # According to #cmake on freenode, libdnf should bundle the FindLibSolv.cmake module
    cp ${libsolv}/share/cmake/Modules/FindLibSolv.cmake libdnf/cmake/modules/

    # libdnf normally wants sphinx to build its hawkey manpages, but we don't care about those manpages since we don't use hawkey
    substituteInPlace configure.ac --replace 'cmake \' 'cmake -DWITH_MAN=off \'

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

