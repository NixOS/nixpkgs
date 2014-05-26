{stdenv, fetchurl, openssl, bison, flex, pam, usePAM ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "monit-5.8.1";
  
  src = fetchurl {
    url = "${meta.homepage}dist/${name}.tar.gz";
    sha256 = "1rbhr3aff8pbiz60r73607hci4yngv5xq1b6yjx9xhks4mwlnpm2";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals usePAM [ pam ];

  configureFlags = [
    "--with-ssl-incl-dir=${openssl}/include"
    "--with-ssl-lib-dir=${openssl}/lib"
  ] ++ stdenv.lib.optionals (! usePAM) [ "--without-pam" ];

  meta = {
    homepage = http://mmonit.com/monit/;
    description = "Monitoring system";
    license = stdenv.lib.licenses.agpl3;
    maintainer = with stdenv.lib.maintainers; [ raskin wmertens ];
  };
}
