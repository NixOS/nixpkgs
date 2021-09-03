{ lib, stdenv, fetchurl, perlPackages, makeWrapper, openssl }:

stdenv.mkDerivation rec {
  pname = "sslmate";
  version = "1.7.1";

  src = fetchurl {
    url = "https://packages.sslmate.com/other/${pname}-${version}.tar.gz";
    sha256 = "1i56za41cfqlml9g787xqqs0r8jifd3y7ks9nf4k2dhhi4rijkj5";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  postInstall = ''
    wrapProgram $out/bin/sslmate --prefix PERL5LIB : \
      "${with perlPackages; makePerlPath [
        URI
        JSONPP
        TermReadKey
      ]}" \
      --prefix PATH : "${openssl.bin}/bin"
  '';

  meta = with lib; {
    homepage = "https://sslmate.com";
    maintainers = [ maintainers.domenkozar ];
    description = "Easy to buy, deploy, and manage your SSL certs";
    platforms = platforms.unix;
    license = licenses.mit; # X11
  };
}
