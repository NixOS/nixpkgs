{stdenv, makeWrapper, fetchurl, perl, openssl, perlPackages }:

stdenv.mkDerivation rec {
  name = "imapsync-1.727";
  src = fetchurl {
    url = "https://releases.pagure.org/imapsync/${name}.tgz";
    sha256 = "1axacjw2wyaphczfw3kfmi5cl83fyr8nb207nks40fxkbs8q5dlr";
  };

  patchPhase = ''
    sed -i -e s@/usr@$out@ Makefile
  '';

  postInstall = ''
    wrapProgram $out/bin/imapsync --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [ perl openssl MailIMAPClient TermReadKey
    IOSocketSSL DigestHMAC URI FileCopyRecursive IOTee UnicodeString
    DataUniqid JSONWebToken TestMockGuard LWP CryptOpenSSLRSA
    LWPProtocolHttps Readonly TestPod TestMockObject ParseRecDescent
    IOSocketInet6 NTLM
  ];

  meta = with stdenv.lib; {
    homepage = http://www.linux-france.org/prj/imapsync/;
    description = "Mail folder synchronizer between IMAP servers";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
