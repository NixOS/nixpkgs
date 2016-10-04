{stdenv, fetchurl, openssl, bison, flex, pam, usePAM ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "monit-5.19.0";

  src = fetchurl {
    url = "${meta.homepage}dist/${name}.tar.gz";
    sha256 = "1f32dz7zzp575d35m8xkgjgrqs2vbls0q6vdzm7wwashcm1xbz5y";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals usePAM [ pam ];

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
