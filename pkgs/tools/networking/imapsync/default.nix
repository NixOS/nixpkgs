{stdenv, makeWrapper, fetchurl, perl, libssl, perlPackages }:

stdenv.mkDerivation rec {
  name = "imapsync-1.644";
  src = fetchurl {
    url = "https://fedorahosted.org/released/imapsync/${name}.tgz";
    sha256 = "1lni950qyp841277dnzb43pxpzqyfcl6sachd8j6a0j08826gfky";
  };

  patchPhase = ''
    sed -i -e s@/usr@$out@ Makefile
  '';

  postInstall = ''
    wrapProgram $out/bin/imapsync --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [ perl libssl MailIMAPClient TermReadKey
    IOSocketSSL DigestHMAC URI FileCopyRecursive IOTee UnicodeString ];

  meta = with stdenv.lib; {
    homepage = http://www.linux-france.org/prj/imapsync/;
    description = "Mail folder synchronizer between IMAP servers";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
