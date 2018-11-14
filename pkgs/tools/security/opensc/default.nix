{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, zlib, readline, openssl
, libiconv, pcsclite, libassuan, libXt
, docbook_xsl, libxslt, docbook_xml_dtd_412
, Carbon
}:

stdenv.mkDerivation rec {
  name = "opensc-${version}";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "10575gb9l38cskq7swyjp0907wlziyxg4ppq33ndz319dsx69d87";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoreconfHook zlib readline openssl pcsclite libassuan
    libXt libxslt libiconv docbook_xml_dtd_412
  ] ++ stdenv.lib.optional stdenv.isDarwin Carbon;

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
    "--with-pcsc-provider=${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so"
  ];

  installFlags = [
    "sysconfdir=$(out)/etc"
    "completiondir=$(out)/etc"
  ];

  meta = with stdenv.lib; {
    description = "Set of libraries and utilities to access smart cards";
    homepage = https://github.com/OpenSC/OpenSC/wiki;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
