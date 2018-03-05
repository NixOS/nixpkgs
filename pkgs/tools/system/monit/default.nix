{stdenv, fetchurl, openssl, bison, flex, pam, zlib, usePAM ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "monit-5.25.1";

  src = fetchurl {
    url = "${meta.homepage}dist/${name}.tar.gz";
    sha256 = "1g417cf6j0v6z233a3625fw1cxsh45xql7ag83jz2988n772ap2b";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ openssl zlib.dev ] ++ stdenv.lib.optionals usePAM [ pam ];

  configureFlags = [
    "--with-ssl-incl-dir=${openssl.dev}/include"
    "--with-ssl-lib-dir=${openssl.out}/lib"
  ] ++ stdenv.lib.optionals (! usePAM) [ "--without-pam" ];

  meta = {
    homepage = http://mmonit.com/monit/;
    description = "Monitoring system";
    license = stdenv.lib.licenses.agpl3;
    maintainers = with stdenv.lib.maintainers; [ raskin wmertens ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
