{ lib, stdenv, fetchurl, perlPackages, makeWrapper, openssl }:

stdenv.mkDerivation rec {
  pname = "sslmate";
  version = "1.9.0";

  src = fetchurl {
    url = "https://packages.sslmate.com/other/${pname}-${version}.tar.gz";
    sha256 = "sha256-PkASJIRJH1kXjegOFMz36QzqT+qUBWslx/iavjFoW5g=";
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
