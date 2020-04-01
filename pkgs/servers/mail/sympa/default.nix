{ stdenv, perl, fetchFromGitHub, autoreconfHook
}:

let
  dataDir = "/var/lib/sympa";
  runtimeDir = "/run/sympa";
  perlEnv = perl.withPackages (p: with p; [
    ArchiveZip
    CGI
    CGIFast
    ClassSingleton
    DateTime
    DBI
    DateTimeFormatMail
    DateTimeTimeZone
    DigestMD5
    Encode
    FCGI
    FileCopyRecursive
    FileNFSLock
    FilePath
    HTMLParser
    HTMLFormatter
    HTMLTree
    HTMLStripScriptsParser
    IO
    IOStringy
    LWP
    libintl_perl

    MHonArc
    MIMEBase64
    MIMECharset
    MIMETools
    MIMEEncWords
    MIMELiteHTML
    MailTools
    NetCIDR
    ScalarListUtils
    SysSyslog
    TermProgressBar
    TemplateToolkit
    URI
    UnicodeLineBreak
    XMLLibXML

    ### Features
    Clone
    CryptEksblowfish

    DBDPg
    DBDSQLite
    DBDmysql

    DataPassword
    EncodeLocale
    IOSocketSSL
    MailDKIM
    NetDNS
    NetLDAP
    NetSMTP
    SOAPLite
  ]);
in
stdenv.mkDerivation rec {
  pname = "sympa";
  version = "6.2.52";

  src = fetchFromGitHub {
    owner = "sympa-community";
    repo = pname;
    rev = version;
    sha256 = "071kx6ryifs2f6fhfky9g297frzp5584kn444af1vb2imzydsbnh";
  };

  configureFlags = [
    "--without-initdir"
    "--without-unitsdir"
    "--without-smrshdir"

    "--with-lockdir=${runtimeDir}"
    "--with-piddir=${runtimeDir}"
    "--with-confdir=${dataDir}/etc"
    "--sysconfdir=${dataDir}/etc"
    "--with-spooldir=${dataDir}/spool"
    "--with-expldir=${dataDir}/list_data"
  ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perlEnv ];
  patches = [ ./make-docs.patch ];

  prePatch = ''
    patchShebangs po/sympa/add-lang.pl
  '';

  preInstall = ''
    mkdir "$TMP/bin"
    for i in chown chgrp chmod; do
      echo '#!${stdenv.shell}' >> "$TMP/bin/$i"
      chmod +x "$TMP/bin/$i"
    done
    PATH="$TMP/bin:$PATH"
  '';

  postInstall = ''
    rm -rf "$TMP/bin"
  '';

  meta = with stdenv.lib; {
    description = "Open source mailing list manager";
    homepage = "https://www.sympa.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sorki mmilata ];
    platforms = platforms.all;
  };
}
