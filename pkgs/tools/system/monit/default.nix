{stdenv, fetchurl, openssl, bison, flex, pam, zlib, usePAM ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "monit-5.20.0";

  src = fetchurl {
    url = "${meta.homepage}dist/${name}.tar.gz";
    sha256 = "13drg4k9r9drn7bpj3n04kkf1l29q05jdccdar6yc6hcqmg3kb7b";
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
