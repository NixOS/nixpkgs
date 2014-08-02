{stdenv, fetchurl, pam, openssl}:

stdenv.mkDerivation {
  name = "uw-imap-2007f";

  src = fetchurl {
    url = "ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz";
    sha256 = "0a2a00hbakh0640r2wdpnwr8789z59wnk7rfsihh3j0vbhmmmqak";
  };

  makeFlags = if stdenv.isDarwin
    then "osx"
    else "lnp" # Linux with PAM modules;
    # -fPIC is required to compile php with imap on x86_64 systems
    + stdenv.lib.optionalString stdenv.isx86_64 " EXTRACFLAGS=-fPIC";

  buildInputs = [ openssl ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) pam;

  patchPhase = ''
    sed -i -e s,/usr/local/ssl,${openssl}, \
      src/osdep/unix/Makefile
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin
    "-I${openssl}/include/openssl";

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include
    cp c-client/*.h c-client/linkage.c $out/include
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
}
