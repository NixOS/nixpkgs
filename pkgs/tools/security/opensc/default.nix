{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, zlib, readline, openssl
, libiconv, pcsclite, libassuan, libXt, fetchpatch
, docbook_xsl, libxslt, docbook_xml_dtd_412
, Carbon, PCSC, buildPackages
, withApplePCSC ? stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "opensc";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "10575gb9l38cskq7swyjp0907wlziyxg4ppq33ndz319dsx69d87";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-6502.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/0d7967549751b7032f22b437106b41444aff0ba9.patch";
      sha256 = "1y42lmz8i9w99hgpakdncnv8f94cqjfabz0v4xg6wfz9akl3ff7d";
    })
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    zlib readline openssl libassuan
    libXt libxslt libiconv docbook_xml_dtd_412
  ]
  ++ stdenv.lib.optional stdenv.isDarwin Carbon
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
        "${stdenv.lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
      }"
    (stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform)
      "XSLTPROC=${buildPackages.libxslt}/bin/xsltproc")
  ];

  PCSC_CFLAGS = stdenv.lib.optionalString withApplePCSC
    "-I${PCSC}/Library/Frameworks/PCSC.framework/Headers";

  installFlags = [
    "sysconfdir=$(out)/etc"
    "completiondir=$(out)/etc"
  ];

  meta = with stdenv.lib; {
    description = "Set of libraries and utilities to access smart cards";
    homepage = https://github.com/OpenSC/OpenSC/wiki;
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.erictapen ];
  };
}
