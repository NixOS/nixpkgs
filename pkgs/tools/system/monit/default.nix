{stdenv, fetchurl, openssl, bison, flex, pam, usePAM ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "monit-5.10";
  
  src = fetchurl {
    url = "${meta.homepage}dist/${name}.tar.gz";
    sha256 = "0lwlils6b59kr6zg328q113c7mrpggqydpq4l6j52sqv3dd1b49p";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals usePAM [ pam ];

  configureFlags = [
    "--with-ssl-incl-dir=${openssl}/include"
    "--with-ssl-lib-dir=${openssl.out}/lib"
  ] ++ stdenv.lib.optionals (! usePAM) [ "--without-pam" ];

  meta = {
    homepage = http://mmonit.com/monit/;
    description = "Monitoring system";
    license = stdenv.lib.licenses.agpl3;
    maintainers = with stdenv.lib.maintainers; [ raskin wmertens ];
  };
}
