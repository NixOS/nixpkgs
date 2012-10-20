{ stdenv, fetchurl, linuxHeaders, readline, openssl, flex, krb5, pam }:

# TODO: These tools are supposed to work under NetBSD and FreeBSD as
# well, so I guess it's not appropriate to place this expression in
# "os-specific/linux/ipsec-tools". Since I cannot verify that the
# expression actually builds on those platforms, I'll leave it here for
# the time being.

stdenv.mkDerivation rec {
  name = "ipsec-tools-0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/ipsec-tools/${name}.tar.bz2";
    sha256 = "2359a24aa8eda9ca7043fc47950c8e6b7f58a07c5d5ad316aa7de2bc5e3a8717";
  };

  buildInputs = [ readline openssl flex krb5 pam ];

  patches = [ ./dont-create-localstatedir-during-install.patch ];

  configureFlags = ''
    --sysconfdir=/etc --localstatedir=/var
    --with-kernel-headers=${linuxHeaders}/include
    --disable-security-context
    --enable-adminport
    --enable-dpd
    --enable-frag
    --enable-gssapi
    --enable-hybrid
    --enable-natt
    --enable-shared
    --enable-stats
  '';

  meta = {
    homepage = "http://ipsec-tools.sourceforge.net/";
    description = "Port of KAME's IPsec utilities to the Linux-2.6 IPsec implementation";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.simons];
  };
}
