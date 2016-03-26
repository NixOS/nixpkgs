{stdenv, makeWrapper, fetchurl, perl, openssl, perlPackages }:

stdenv.mkDerivation rec {
  name = "imapsync-1.678";
  src = fetchurl {
    url = "https://fedorahosted.org/released/imapsync/${name}.tgz";
    sha256 = "1xx9brizz997i6cmsy8gzm349kgf35qm1vxh5zq4cv84gfy23k1r";
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
    LWPProtocolHttps
  ];

  meta = with stdenv.lib; {
    homepage = http://www.linux-france.org/prj/imapsync/;
    description = "Mail folder synchronizer between IMAP servers";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
