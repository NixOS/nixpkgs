{ stdenv, fetchurl, perlPackages, perl, makeWrapper, openssl }:

stdenv.mkDerivation rec {
  name = "sslmate-1.6.0";

  src = fetchurl {
    url = "https://packages.sslmate.com/other/${name}.tar.gz";
    sha256 = "1ypabdk0nlqjzpmn3m1szjyw7yq20svgbm92sqd5wqmsapyn3a6s";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ perl makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/sslmate --prefix PERL5LIB : \
      "${with perlPackages; stdenv.lib.makePerlPath [
        URI
        JSONPP
        TermReadKey
      ]}" \
      --prefix PATH : "${openssl.bin}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://sslmate.com;
    maintainers = [ maintainers.domenkozar ];
    description = "Easy to buy, deploy, and manage your SSL certs";
    platforms = platforms.unix;
    license = licenses.mit; # X11
  };
}
