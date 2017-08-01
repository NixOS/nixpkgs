{ stdenv, fetchurl, fetchpatch, linuxHeaders, readline, openssl, flex, kerberos, pam }:

# TODO: These tools are supposed to work under NetBSD and FreeBSD as
# well, so I guess it's not appropriate to place this expression in
# "os-specific/linux/ipsec-tools". Since I cannot verify that the
# expression actually builds on those platforms, I'll leave it here for
# the time being.

stdenv.mkDerivation rec {
  name = "ipsec-tools-0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/ipsec-tools/${name}.tar.bz2";
    sha256 = "0b9gfbz78k2nj0k7jdlm5kajig628ja9qm0z5yksiwz22s3v7dlf";
  };

  buildInputs = [ readline openssl flex kerberos pam ];

  patches = [
    ./dont-create-localstatedir-during-install.patch
    ./CVE-2015-4047.patch
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-ipsec-tools/pkg-ipsec-tools.git/plain/debian/patches/CVE-2016-10396.patch?id=62ac12648a4eb7c5ba5dba0f81998d1acf310d8b";
      sha256 = "1kf7j2pf1blni52z7q41n0yisqb7gvk01lvldr319zaxxg7rm84a";
    })
  ];

  # fix build with newer gcc versions
  preConfigure = ''substituteInPlace configure --replace "-Werror" "" '';

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
  };
}
