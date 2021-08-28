{ lib, stdenv, makeWrapper, fetchFromGitHub, perl, openssl, perlPackages, procps }:

stdenv.mkDerivation rec {
  pname = "imapsync";
  version = "2.140";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1k4rf582c3434yxj9brsjz0awakd84xwikghyq0h54darqwfm23j";
  };

  patches = [
    ./patch-makefile.patch
    ./patch-prerequisites.patch
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/imapsync --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [
    perl
    openssl
    CGI
    EncodeIMAPUTF7
    FileTail
    ModuleScanDeps
    PackageStashXS
    MailIMAPClient
    TermReadKey
    IOSocketSSL
    DigestHMAC
    URI
    FileCopyRecursive
    IOTee
    UnicodeString
    DataUniqid
    JSONWebToken
    TestMockGuard
    LWP
    CryptOpenSSLRSA
    LWPProtocolHttps
    Readonly
    RegexpCommon
    SysMemInfo
    TestDeep
    TestFatal
    TestPod
    TestRequires
    TestMockObject
    ParseRecDescent
    IOSocketInet6
    NTLM
  ] ++ [ procps ];

  meta = with lib; {
    homepage = "https://imapsync.lamiral.info/";
    description = "Mail folder synchronizer between IMAP servers";
    license = licenses.nlpl;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
