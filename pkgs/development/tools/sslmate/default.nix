{ stdenv, fetchurl, perlPackages, makeWrapper, openssl }:

stdenv.mkDerivation rec {
  name = "sslmate-1.7.0";

  src = fetchurl {
    url = "https://packages.sslmate.com/other/${name}.tar.gz";
    sha256 = "0vhppvy5vphipbycfilzxdly7nw12brscz4biawf3bl376yp7ljm";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ perlPackages.perl makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/sslmate --prefix PERL5LIB : \
      "${with perlPackages; makePerlPath [
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
