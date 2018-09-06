{ stdenv, fetchurl, makeWrapper
, perl, perlPackages, libassuan, libgcrypt
}:

stdenv.mkDerivation rec {
  name = "monkeysphere-${version}";
  version = "0.41";

  src = fetchurl {
    url = "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${version}.orig.tar.gz";
    sha256 = "0jz7kwkwgylqprnl8bwvl084s5gjrilza77ln18i3f6x48b2y6li";
  };

  buildInputs = [ makeWrapper perl libassuan libgcrypt ];

  patches = [ ./monkeysphere.patch ];

  makeFlags = ''
    PREFIX=/
    DESTDIR=$(out)
  '';

  postInstall = ''
    wrapProgram $out/bin/openpgp2ssh --prefix PERL5LIB : \
      "${with perlPackages; stdenv.lib.makePerlPath [
        CryptOpenSSLRSA
        CryptOpenSSLBignum
      ]}"
    wrapProgram $out/bin/monkeysphere --prefix PERL5LIB :\
      "${with perlPackages; stdenv.lib.makePerlPath [
        CryptOpenSSLRSA
        CryptOpenSSLBignum
      ]}"
  '';

  meta = with stdenv.lib; {
    homepage = http://web.monkeysphere.info/;
    description = "Leverage the OpenPGP web of trust for SSH and TLS authentication";
    longDescription = ''
      The Monkeysphere project's goal is to extend OpenPGP's web of
      trust to new areas of the Internet to help us securely identify
      servers we connect to, as well as each other while we work online.
      The suite of Monkeysphere utilities provides a framework to
      transparently leverage the web of trust for authentication of
      TLS/SSL communications through the normal use of tools you are
      familiar with, such as your web browser0 or secure shell.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ primeos ];
  };
}
