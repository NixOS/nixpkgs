{lib, stdenv, fetchurl, openssl}:
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

  patches = [
    (fetchurl {
      url = "https://github.com/muquit/mailsend/commit/960df6d7a11eef90128dc2ae660866b27f0e4336.patch";
      sha256 = "0vz373zcfl19inflybfjwshcq06rvhx0i5g0f4b021cxfhyb1sm0";
    })
  ];
  meta = {
    inherit (s) version;
    description = "CLI email sending tool";
    license = lib.licenses.bsd3 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/muquit/mailsend";
    downloadPage = "https://github.com/muquit/mailsend/releases";
  };
}
