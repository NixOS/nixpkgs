{stdenv, fetchurl, pam, openssl}:

stdenv.mkDerivation {
  name = "uw-imap-2007";

  src = fetchurl {
    url = "ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz";
    sha256 = "0a2a00hbakh0640r2wdpnwr8789z59wnk7rfsihh3j0vbhmmmqak";
  };

  makeFlags = "lnp"; # Linux with PAM modules

  buildInputs = [ pam openssl ];

  patchPhase = ''
    sed -i -e s,/usr/local/ssl,${openssl}, \
      src/osdep/unix/Makefile
  '';

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
    license = "Apache2";
    platforms = with stdenv.lib.platforms; linux;
  };

  passthru = {
    withSSL = true;
  };
}
