{stdenv, fetchurl, perl, openssl, MailIMAPClient}:

stdenv.mkDerivation rec {
  name = "imapsync-1.267";
  src = fetchurl {
    url = http://www.linux-france.org/prj/imapsync/dist/imapsync-1.267.tgz;
    sha256 = "0h9np2b4bdfnhn10cqkw66fki26480w0c8m3bxw0p76xkaggywdy";
  };
  patchPhase = ''
    sed -i -e s@/usr@$out@ Makefile
  '';

  postInstall = ''
    # Add Mail::IMAPClient to the runtime search path.
    substituteInPlace $out/bin/imapsync --replace '/bin/perl' '/bin/perl -I${MailIMAPClient}/lib/perl5/site_perl';
  '';
  buildInputs = [perl openssl MailIMAPClient];

  meta = {
    homepage = "http://www.linux-france.org/prj/imapsync/";
    description = "Mail folder synchronizer between IMAP servers";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
