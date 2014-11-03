{stdenv, fetchurl, openssl}:
let
  s = # Generated upstream information
  rec {
    baseName="mailsend";
    version="1.17b15";
    name="${baseName}-${version}";
    hash="0sxjrv9yn2xyjak9si0gw2zalsrfqqcvz0indq9ap5fyalj1pjvk";
    url="https://github.com/muquit/mailsend/archive/1.17b15.tar.gz";
    sha256="0sxjrv9yn2xyjak9si0gw2zalsrfqqcvz0indq9ap5fyalj1pjvk";
  };
  buildInputs = [
    openssl
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  configureFlags = [
    "--with-openssl=${openssl}"
  ];
  meta = {
    inherit (s) version;
    description = ''CLI email sending tool'';
    license = stdenv.lib.licenses.bsd3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://github.com/muquit/mailsend";
    downloadPage = "https://github.com/muquit/mailsend/releases";
  };
}
