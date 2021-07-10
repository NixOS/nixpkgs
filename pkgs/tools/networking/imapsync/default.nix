{lib, stdenv, makeWrapper, fetchFromGitHub, perl, openssl, perlPackages, procps }:

stdenv.mkDerivation rec {
  pname = "imapsync";
  version = "1.977";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1a9dpnzmi2lhqwj3skvxl62kc911my0x64x2djqn89cj52c5lhaa";
  };

  patchPhase = ''
    sed -i -e s@/usr@$out@ Makefile
  '';

  postInstall = ''
    wrapProgram $out/bin/imapsync --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [ perl openssl CGI EncodeIMAPUTF7 FileTail ModuleScanDeps PackageStashXS MailIMAPClient TermReadKey
    IOSocketSSL DigestHMAC URI FileCopyRecursive IOTee UnicodeString
    DataUniqid JSONWebToken TestMockGuard LWP CryptOpenSSLRSA
    LWPProtocolHttps Readonly RegexpCommon SysMemInfo TestDeep TestFatal TestPod TestRequires TestMockObject PARPacker ParseRecDescent
    IOSocketInet6 NTLM
  ] ++ [ procps ];

  meta = with lib; {
    homepage = "https://imapsync.lamiral.info/";
    description = "Mail folder synchronizer between IMAP servers";
    license = licenses.nlpl;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
