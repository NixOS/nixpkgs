{ lib, stdenv
, fetchurl, bison, flex
, zlib
, usePAM ? stdenv.hostPlatform.isLinux, pam
, useSSL ? true, openssl
}:

stdenv.mkDerivation rec {
  name = "monit-5.27.1";

  src = fetchurl {
    url = "${meta.homepage}dist/${name}.tar.gz";
    sha256 = "0lgdhif6x11fcpli0qn138rpdvrfnwmkzsy4lc9pas45c78hhx7m";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ zlib.dev ] ++
    lib.optionals useSSL [ openssl ] ++
    lib.optionals usePAM [ pam ];

  configureFlags = [
    (lib.withFeature usePAM "pam")
  ] ++ (if useSSL then [
      "--with-ssl-incl-dir=${openssl.dev}/include"
      "--with-ssl-lib-dir=${openssl.out}/lib"
    ] else [
      "--without-ssl"
  ]) ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # will need to check both these are true for musl
    "libmonit_cv_setjmp_available=yes"
    "libmonit_cv_vsnprintf_c99_conformant=yes"
  ];

  meta = {
    homepage = "http://mmonit.com/monit/";
    description = "Monitoring system";
    license = lib.licenses.agpl3;
    maintainers = with lib.maintainers; [ raskin wmertens ];
    platforms = with lib.platforms; linux;
  };
}
