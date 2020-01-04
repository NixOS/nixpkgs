{ stdenv, fetchurl, fetchpatch, pam, openssl }:

stdenv.mkDerivation ({
  name = "uw-imap-2007f";

  src = fetchurl {
    url = "ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz";
    sha256 = "0a2a00hbakh0640r2wdpnwr8789z59wnk7rfsihh3j0vbhmmmqak";
  };

  makeFlags = [ (if stdenv.isDarwin
    then "osx"
    else "lnp") ]  # Linux with PAM modules;
    # -fPIC is required to compile php with imap on x86_64 systems
    ++ stdenv.lib.optional stdenv.isx86_64 "EXTRACFLAGS=-fPIC"
    ++ stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "CC=${stdenv.hostPlatform.config}-gcc" "RANLIB=${stdenv.hostPlatform.config}-ranlib" ];

  hardeningDisable = [ "format" ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) pam;

  patches = [ (fetchpatch {
    url = "https://salsa.debian.org/holmgren/uw-imap/raw/dcb42981201ea14c2d71c01ebb4a61691b6f68b3/debian/patches/1006_openssl1.1_autoverify.patch";
    sha256 = "09xb58awvkhzmmjhrkqgijzgv7ia381ablf0y7i1rvhcqkb5wga7";
  }) ];

  postPatch = ''
    sed -i src/osdep/unix/Makefile -e 's,/usr/local/ssl,${openssl.dev},'
    sed -i src/osdep/unix/Makefile -e 's,^SSLCERTS=.*,SSLCERTS=/etc/ssl/certs,'
    sed -i src/osdep/unix/Makefile -e 's,^SSLLIB=.*,SSLLIB=${openssl.out}/lib,'
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin
    "-I${openssl.dev}/include/openssl";

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include/c-client
    cp c-client/*.h osdep/unix/*.h c-client/linkage.c c-client/auths.c $out/include/c-client/
    cp c-client/c-client.a $out/lib/libc-client.a
    cp mailutil/mailutil imapd/imapd dmail/dmail mlock/mlock mtest/mtest tmail/tmail \
      tools/{an,ua} $out/bin
  '';

  meta = {
    homepage = http://www.washington.edu/imap/;
    description = "UW IMAP toolkit - IMAP-supporting software developed by the UW";
    license = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; linux;
  };

  passthru = {
    withSSL = true;
  };
} // stdenv.lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
  # This is set here to prevent rebuilds on native compilation.
  # Configure phase is a no-op there, because this package doesn't use ./configure scripts.
  configurePhase = ''
    echo "Cross-compilation, injecting make flags"
    makeFlagsArray+=("ARRC=${stdenv.hostPlatform.config}-ar rc")
  '';
})
