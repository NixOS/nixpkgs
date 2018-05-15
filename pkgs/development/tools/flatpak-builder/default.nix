{ stdenv
, fetchurl
, substituteAll

, autoreconfHook
, docbook_xml_dtd_412
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, docbook_xsl
, gettext
, libxml2
, libxslt
, pkgconfig
, xmlto

, acl
, bazaar
, binutils
, bzip2
, coreutils
, cpio
, elfutils
, flatpak
, gitMinimal
, glib
, gnutar
, json_glib
, libcap
, libdwarf
, libsoup
, ostree
, patch
, rpm
, unzip
}:

let
  version = "0.10.10";
in stdenv.mkDerivation rec {
  name = "flatpak-builder-${version}";

  outputs = [ "out" "doc" "man" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak-builder/releases/download/${version}/${name}.tar.xz";
    sha256 = "0b0c2rmf2vj596600blbhsiv2dg7qwpr33lgdcn0bnqc4ddri6f2";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_412
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    libxml2
    libxslt
    pkgconfig
    xmlto
  ];

  buildInputs = [
    acl
    bzip2
    elfutils
    flatpak
    glib
    json_glib
    libcap
    libdwarf
    libsoup
    libxml2
    ostree
  ];

  patches = [
    # patch taken from gtk_doc
    ./respect-xml-catalog-files-var.patch
    (substituteAll {
      src = ./fix-paths.patch;
      bzr = "${bazaar}/bin/bzr";
      cp = "${coreutils}/bin/cp";
      patch = "${patch}/bin/patch";
      tar = "${gnutar}/bin/tar";
      unzip = "${unzip}/bin/unzip";
      rpm2cpio = "${rpm}/bin/rpm2cpio";
      cpio = "${cpio}/bin/cpio";
      git = "${gitMinimal}/bin/git";
      rofilesfuse = "${ostree}/bin/rofiles-fuse";
      strip = "${binutils}/bin/strip";
      eustrip = "${elfutils}/bin/eu-strip";
      euelfcompress = "${elfutils}/bin/eu-elfcompress";
    })
  ];

  meta = with stdenv.lib; {
    description = "Tool to build flatpaks from source";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
