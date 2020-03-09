{ stdenv, lib, fetchurl, pkgconfig, cmake, perlPackages, curl, gtest
, gnutls, libtasn1, lzma, bzip2, lz4, zstd, libseccomp, udev
, db, dpkg, libxslt, docbook_xsl, docbook_xml_dtd_45

# used when WITH_DOC=ON
, w3m
, doxygen

# used when WITH_NLS=ON
, gettext

# opts
, withDocs ? true
, withNLS ? true
}:

stdenv.mkDerivation rec {
  pname = "apt";
  version = "1.8.4";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/apt/apt_${version}.tar.xz";
    sha256 = "0gn4srqaaym85gc8nldqkv01477kdwr136an2nlpbdrsbx3y83zl";
  };

  nativeBuildInputs = [ pkgconfig cmake gtest libxslt.bin ];

  buildInputs = [
    perlPackages.perl curl gnutls libtasn1 lzma bzip2 lz4 zstd libseccomp udev db dpkg
  ] ++ lib.optionals withDocs [
    doxygen perlPackages.Po4a w3m docbook_xml_dtd_45
  ] ++ lib.optionals withNLS [
    gettext
  ];

  cmakeFlags = [
    "-DBERKELEY_DB_INCLUDE_DIRS=${db.dev}/include"
    "-DGNUTLS_INCLUDE_DIR=${gnutls.dev}/include"
    "-DDOCBOOK_XSL=${docbook_xsl}/share/xml/docbook-xsl"
    "-DROOT_GROUP=root"
    "-DWITH_DOC=${if withDocs then "ON" else "OFF"}"
    "-DUSE_NLS=${if withNLS then "ON" else "OFF"}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Command-line package management tools used on Debian-based systems";
    homepage = https://salsa.debian.org/apt-team/apt;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
