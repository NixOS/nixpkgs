{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pam,
  openssl,
  libkrb5,
}:

stdenv.mkDerivation rec {
  pname = "uw-imap";
  version = "2007f";

  src = fetchurl {
    url = "ftp://ftp.cac.washington.edu/imap/imap-${version}.tar.gz";
    sha256 = "0a2a00hbakh0640r2wdpnwr8789z59wnk7rfsihh3j0vbhmmmqak";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
    (if stdenv.isDarwin then "osx" else "lnp") # Linux with PAM modules;
  ] ++ lib.optional stdenv.isx86_64 "EXTRACFLAGS=-fPIC"; # -fPIC is required to compile php with imap on x86_64 systems

  hardeningDisable = [ "format" ];

  buildInputs = [
    openssl
    (if stdenv.isDarwin then libkrb5 else pam) # Matches the make target.
  ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/holmgren/uw-imap/raw/dcb42981201ea14c2d71c01ebb4a61691b6f68b3/debian/patches/1006_openssl1.1_autoverify.patch";
      sha256 = "09xb58awvkhzmmjhrkqgijzgv7ia381ablf0y7i1rvhcqkb5wga7";
    })
    # Required to build with newer versions of clang. Fixes call to undeclared functions errors
    # and incompatible function pointer conversions.
    ./clang-fix.patch
  ];

  postPatch = ''
    sed -i src/osdep/unix/Makefile -e 's,/usr/local/ssl,${openssl.dev},'
    sed -i src/osdep/unix/Makefile -e 's,^SSLCERTS=.*,SSLCERTS=/etc/ssl/certs,'
    sed -i src/osdep/unix/Makefile -e 's,^SSLLIB=.*,SSLLIB=${lib.getLib openssl}/lib,'
  '';

  preConfigure = ''
    makeFlagsArray+=("ARRC=${stdenv.cc.targetPrefix}ar rc")
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${openssl.dev}/include/openssl";

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include/c-client
    cp c-client/*.h osdep/unix/*.h c-client/linkage.c c-client/auths.c $out/include/c-client/
    cp c-client/c-client.a $out/lib/libc-client.a
    cp mailutil/mailutil imapd/imapd dmail/dmail mlock/mlock mtest/mtest tmail/tmail \
      tools/{an,ua} $out/bin
  '';

  meta = with lib; {
    homepage = "https://www.washington.edu/imap/";
    description = "UW IMAP toolkit - IMAP-supporting software developed by the UW";
    license = licenses.asl20;
    platforms = platforms.unix;
  };

  passthru = {
    withSSL = true;
  };
}
