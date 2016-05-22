{stdenv, fetchurl, openssl}:
let
  s = # Generated upstream information
  rec {
    baseName="mailsend";
    version="1.18";
    name="${baseName}-${version}";
    hash="1fjrb6q7y2dxx0qz7r0wlhqfkjqq1vfh7yb7jl77h5qi5kd5rm46";
    url="https://github.com/muquit/mailsend/archive/1.18.tar.gz";
    sha256="1fjrb6q7y2dxx0qz7r0wlhqfkjqq1vfh7yb7jl77h5qi5kd5rm46";
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
    homepage = "https://github.com/muquit/mailsend";
    downloadPage = "https://github.com/muquit/mailsend/releases";
  };
}
