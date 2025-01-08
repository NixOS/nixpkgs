{
  lib,
  fetchurl,
  mkTclDerivation,
  openssl,
}:

mkTclDerivation rec {
  pname = "tcltls";
  version = "1.7.22";

  src = fetchurl {
    url = "https://core.tcl-lang.org/tcltls/uv/tcltls-${version}.tar.gz";
    sha256 = "sha256-6E4reideyCxKqp0bH5eG2+Q1jIFekXU5/+f2Z/9Lw7Q=";
  };

  buildInputs = [ openssl ];

  configureFlags = [
    "--with-ssl-dir=${openssl.dev}"
  ];

  meta = {
    homepage = "https://core.tcl-lang.org/tcltls/index";
    description = "OpenSSL / RSA-bsafe Tcl extension";
    maintainers = [ lib.maintainers.agbrooks ];
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
}
