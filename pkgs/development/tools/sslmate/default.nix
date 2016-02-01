{ stdenv, fetchurl, perlPackages, perl, makeWrapper, openssl }:

stdenv.mkDerivation rec {
  name = "sslmate-1.5.0";

  src = fetchurl {
    url = "https://packages.sslmate.com/other/${name}.tar.gz";
    sha256 = "1vxdkydwww4awi6ishvq68jvlj6vkbfw7pin1cdqpl84vs9q7ycg";
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
    maintainers = [ maintainers.iElectric ];
    description = "Easy to buy, deploy, and manage your SSL certs";
    platforms = platforms.unix;
    license = licenses.mit; # X11
  };
}
