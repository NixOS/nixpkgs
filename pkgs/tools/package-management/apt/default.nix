{ stdenv, lib, fetchzip, pkgconfig, cmake, perl, curl, gtest, lzma, bzip2 , lz4
, db, dpkg, libxslt, docbook_xsl, docbook_xml_dtd_45

# used when WITH_DOC=ON
, w3m
, Po4a
, doxygen

# used when WITH_NLS=ON
, gettext

# opts
, withDocs ? true
, withNLS ? true
}:

stdenv.mkDerivation rec {
  name = "apt-${version}";

  version = "1.4.6";

  src = fetchzip {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/apt_${version}.tar.xz";
    sha256 = "0ahwhmscrmnpvl1r732wg93dzkhv8c1sph2yrqgsrhr73c1616ix";
  };

  buildInputs = [
    pkgconfig cmake perl curl gtest lzma bzip2 lz4 db dpkg libxslt.bin
  ] ++ lib.optionals withDocs [
    doxygen Po4a w3m
  ] ++ lib.optionals withNLS [
    gettext
  ];

  preConfigure = ''
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}${Po4a}/lib/perl5";

    cmakeFlagsArray+=(
      -DBERKELEY_DB_INCLUDE_DIRS="${db}"/include
      -DDOCBOOK_XSL="${docbook_xsl}"/share/xml/docbook-xsl
      -DROOT_GROUP=root
      -DWITH_DOC=${if withDocs then "ON" else "OFF"}
      -DUSE_NLS=${if withNLS then "ON" else "OFF"}
    )

    for f in doc/*; do
      if [[ -f "$f" ]]; then
        substituteInPlace "$f" \
          --replace \
            "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
            "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
      fi
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "";
    homepage = https://launchpad.net/ubuntu/+source/apt;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
