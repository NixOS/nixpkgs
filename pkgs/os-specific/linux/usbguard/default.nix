{ stdenv, fetchFromGitHub, lib, autoreconfHook,
  pkgconfig, libxslt, libxml2, docbook_xml_dtd_45, docbook_xsl, asciidoc,
  dbus-glib, libcap_ng, libqb, libseccomp, polkit, protobuf,
  audit,
  libgcrypt ? null,
  libsodium ? null
}:

with stdenv.lib;

assert libgcrypt != null -> libsodium == null;

stdenv.mkDerivation rec {
  version = "1.0.0";
  pname = "usbguard";

  src = fetchFromGitHub {
    owner = "USBGuard";
    repo = pname;
    rev = "usbguard-${version}";
    sha256 = "sha256-CPuBQmDOpXWn0jPo4HRyDCZUpDy5NmbvUHxXoVbMd/I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
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
    description = "The USBGuard software framework helps to protect your computer against BadUSB";
    homepage = "https://usbguard.github.io/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.tnias ];
  };
}
