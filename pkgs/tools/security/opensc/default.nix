{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, zlib, readline, openssl
, libiconv, pcsclite, libassuan, libXt
, fetchpatch
, docbook_xsl, libxslt, docbook_xml_dtd_412
, Carbon, PCSC, buildPackages
, withApplePCSC ? stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "opensc";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "sha256-Yo8dwk7+d6q+hi7DmJ0GJM6/pmiDOiyEm/tEBSbCU8k=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-2977.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/81944d1529202bd28359bede57c0a15deb65ba8a.patch";
      hash = "sha256-rCeYYKPtv3pii5zgDP5x9Kl2r98p3uxyBSCYlPJZR/s=";
    })
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    zlib readline openssl libassuan
    libXt libxslt libiconv docbook_xml_dtd_412
  ]
  ++ lib.optional stdenv.isDarwin Carbon
  ++ (if withApplePCSC then [ PCSC ] else [ pcsclite ]);

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

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
    maintainers = [ maintainers.michaeladler ];
  };
}
