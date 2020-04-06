{
  stdenv, fetchurl, lib,
  pkgconfig, libxslt, libxml2, docbook_xml_dtd_45, docbook_xsl, asciidoc,
  dbus-glib, libcap_ng, libqb, libseccomp, polkit, protobuf,
  audit,
  libgcrypt ? null,
  libsodium ? null
}:

with stdenv.lib;

assert libgcrypt != null -> libsodium == null;

stdenv.mkDerivation rec {
  version = "0.7.6";
  pname = "usbguard";

  repo = "https://github.com/USBGuard/usbguard";

  src = fetchurl {
    url = "${repo}/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0gzhs8s4aka86mkcjib36z54si939ki4bmk46p6v8kln1fixad3j";
  };

  nativeBuildInputs = [
    asciidoc
    pkgconfig
    libxslt # xsltproc
    libxml2 # xmllint
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = [
    dbus-glib
    libcap_ng
    libqb
    libseccomp
    polkit
    protobuf
    audit
  ]
  ++ (lib.optional (libgcrypt != null) libgcrypt)
  ++ (lib.optional (libsodium != null) libsodium);

  configureFlags = [
    "--with-bundled-catch"
    "--with-bundled-pegtl"
    "--with-dbus"
    "--with-polkit"
  ]
  ++ (lib.optional (libgcrypt != null) "--with-crypto-library=gcrypt")
  ++ (lib.optional (libsodium != null) "--with-crypto-library=sodium");

  enableParallelBuilding = true;

  meta = {
    description = "The USBGuard software framework helps to protect your computer against BadUSB.";
    homepage = "https://usbguard.github.io/";
    license = licenses.gpl2;
    maintainers = [ maintainers.tnias ];
  };
}
