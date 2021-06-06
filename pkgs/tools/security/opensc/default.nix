{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, zlib, readline, openssl
, libiconv, pcsclite, libassuan, libXt
, docbook_xsl, libxslt, docbook_xml_dtd_412
, Carbon, PCSC, buildPackages
, withApplePCSC ? stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "opensc";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "sha256-OjOfA1pIu8NeN+hPuow5UVMKsg0PrsLojw5h05/Qm+o=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    zlib readline openssl libassuan
    libXt libxslt libiconv docbook_xml_dtd_412
  ]
  ++ lib.optional stdenv.isDarwin Carbon
  ++ (if withApplePCSC then [ PCSC ] else [ pcsclite ]);

  NIX_CFLAGS_COMPILE = "-Wno-error";

  configureFlags = [
    "--enable-zlib"
    "--enable-readline"
    "--enable-openssl"
    "--enable-pcsc"
    "--enable-sm"
    "--enable-man"
    "--enable-doc"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-xsl-stylesheetsdir=${docbook_xsl}/xml/xsl/docbook"
    "--with-pcsc-provider=${
      if withApplePCSC then
        "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
      else
        "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
      }"
    (lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform)
      "XSLTPROC=${buildPackages.libxslt}/bin/xsltproc")
  ];

  PCSC_CFLAGS = lib.optionalString withApplePCSC
    "-I${PCSC}/Library/Frameworks/PCSC.framework/Headers";

  installFlags = [
    "sysconfdir=$(out)/etc"
    "completiondir=$(out)/etc"
  ];

  meta = with lib; {
    description = "Set of libraries and utilities to access smart cards";
    homepage = "https://github.com/OpenSC/OpenSC/wiki";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.erictapen ];
  };
}
