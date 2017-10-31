{stdenv, fetchurl, openssl}:
let
  s = # Generated upstream information
  rec {
    baseName="mailsend";
    version="1.19";
    name="${baseName}-${version}";
    hash="1xwk6jvl5li8ddlik1lj88qswnyminp9wlf5cm8gg3n54szgcpjn";
    url="https://github.com/muquit/mailsend/archive/1.19.tar.gz";
    sha256="1xwk6jvl5li8ddlik1lj88qswnyminp9wlf5cm8gg3n54szgcpjn";
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
    "--with-openssl=${openssl.dev}"
  ];
  meta = {
    inherit (s) version;
    description = ''CLI email sending tool'';
    license = stdenv.lib.licenses.bsd3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://github.com/muquit/mailsend;
    downloadPage = "https://github.com/muquit/mailsend/releases";
  };
}
