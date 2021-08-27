{lib, stdenv, makeWrapper, fetchFromGitHub, perl, openssl, perlPackages, procps }:

stdenv.mkDerivation rec {
  pname = "imapsync";
  version = "1.727";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0ckd968aimrxr6w7p6y67xspjbc9yijv7s7pc2yaricxxg26pg3q";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/imapsync --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [ perl openssl MailIMAPClient TermReadKey
    IOSocketSSL DigestHMAC URI FileCopyRecursive IOTee UnicodeString
    DataUniqid JSONWebToken TestMockGuard LWP CryptOpenSSLRSA
    LWPProtocolHttps Readonly TestPod TestMockObject ParseRecDescent
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
