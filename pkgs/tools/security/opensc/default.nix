{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, zlib, readline, openssl
, libiconv, pcsclite, libassuan, libXt, fetchpatch
, docbook_xsl, libxslt, docbook_xml_dtd_412
, Carbon, PCSC, buildPackages
, withApplePCSC ? stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "opensc";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "0mg8qmhww3li1isfgvn5hang1hq58zra057ilvgci88csfziv5lv";
  };

  patches = [
    (fetchpatch {
      # https://nvd.nist.gov/vuln/detail/CVE-2020-26570
      name = "CVE-2020-26570.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/6903aebfddc466d966c7b865fae34572bf3ed23e.patch";
      sha256 = "sha256-aB9iCVcdp9zFhZiSv5A399Ttj7NUHRVgXr0EfmMwKN4=";
    })
    (fetchpatch {
      # https://nvd.nist.gov/vuln/detail/CVE-2020-26572
      name = "CVE-2020-26572.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/9d294de90d1cc66956389856e60b6944b27b4817.patch";
      sha256 = "sha256-gKJaR5K+NaXh4NeTkGpzHzHCdpt6n54Hnt1GAq0tA9o=";
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
    homepage = "https://github.com/OpenSC/OpenSC/wiki";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.erictapen ];
  };
}
