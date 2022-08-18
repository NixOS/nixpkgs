{ lib
, stdenv
, fetchurl
, bzip2
, cmake
, curl
, db
, docbook_xml_dtd_45
, docbook_xsl
, dpkg
, gnutls
, gtest
, libgcrypt
, libseccomp
, libtasn1
, libxslt
, lz4
, perlPackages
, pkg-config
, triehash
, udev
, xxHash
, xz
, zstd
, withDocs ? true , w3m, doxygen
, withNLS ? true , gettext
}:

stdenv.mkDerivation rec {
  pname = "apt";
  version = "2.5.2";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/apt/apt_${version}.tar.xz";
    hash = "sha256-zFw3TCgxyeOQ2cXwgCmoHDyit3irwN0UJsgcZXYo/p0=";
  };

  nativeBuildInputs = [
    cmake
    gtest
    libxslt.bin
    pkg-config
    triehash
  ];

  buildInputs = [
    bzip2
    curl
    db
    dpkg
    gnutls
    libgcrypt
    libseccomp
    libtasn1
    lz4
    perlPackages.perl
    udev
    xxHash
    xz
    zstd
  ] ++ lib.optionals withDocs [
    docbook_xml_dtd_45
    doxygen
    perlPackages.Po4a
    w3m
  ] ++ lib.optionals withNLS [
    gettext
  ];

  cmakeFlags = [
    "-DBERKELEY_INCLUDE_DIRS=${db.dev}/include"
    "-DDOCBOOK_XSL=${docbook_xsl}/share/xml/docbook-xsl"
    "-DGNUTLS_INCLUDE_DIR=${gnutls.dev}/include"
    "-DROOT_GROUP=root"
    "-DUSE_NLS=${lib.boolToCMakeString withNLS}"
    "-DWITH_DOC=${lib.boolToCMakeString withDocs}"
  ];

  meta = with lib; {
    homepage = "https://salsa.debian.org/apt-team/apt";
    description = "Command-line package management tools used on Debian-based systems";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
