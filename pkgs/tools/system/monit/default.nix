{ stdenv
, fetchurl, bison, flex
, zlib
, usePAM ? stdenv.hostPlatform.isLinux, pam
, useSSL ? true, openssl
}:

stdenv.mkDerivation rec {
  name = "monit-5.25.3";

  src = fetchurl {
    url = "${meta.homepage}dist/${name}.tar.gz";
    sha256 = "0s8577ixcmx45b081yx6cw54iq7m5yzpq3ir616qc84xhg45h0n1";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ zlib.dev ] ++
    stdenv.lib.optionals useSSL [ openssl ] ++
    stdenv.lib.optionals usePAM [ pam ];

  configureFlags = [
    (stdenv.lib.withFeature usePAM "pam")
  ] ++ (if useSSL then [
      "--with-ssl-incl-dir=${openssl.dev}/include"
      "--with-ssl-lib-dir=${openssl.out}/lib"
    ] else [
      "--without-ssl"
  ]) ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # will need to check both these are true for musl
    "libmonit_cv_setjmp_available=yes"
    "libmonit_cv_vsnprintf_c99_conformant=yes"
  ];

  meta = {
    homepage = http://mmonit.com/monit/;
    description = "Monitoring system";
    license = stdenv.lib.licenses.agpl3;
    maintainers = with stdenv.lib.maintainers; [ raskin wmertens ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
