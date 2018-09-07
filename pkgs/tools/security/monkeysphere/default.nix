{ stdenv, fetchurl, makeWrapper
, perl, libassuan, libgcrypt
, perlPackages, lockfileProgs, gnupg
}:

stdenv.mkDerivation rec {
  name = "monkeysphere-${version}";
  version = "0.41";

  src = fetchurl {
    url = "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${version}.orig.tar.gz";
    sha256 = "0jz7kwkwgylqprnl8bwvl084s5gjrilza77ln18i3f6x48b2y6li";
  };

  patches = [ ./monkeysphere.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl libassuan libgcrypt ];

  makeFlags = ''
    PREFIX=/
    DESTDIR=$(out)
  '';

  postFixup =
    let wrapMonkeysphere = runtimeDeps: program:
          "wrapProgram $out/bin/${program} --prefix PERL5LIB : "
            + (with perlPackages; stdenv.lib.makePerlPath [
                CryptOpenSSLRSA
                CryptOpenSSLBignum
              ])
            + stdenv.lib.optionalString
                (builtins.length runtimeDeps > 0)
                " --prefix PATH : ${stdenv.lib.makeBinPath runtimeDeps}"
            + "\n";
        wrapPrograms = runtimeDeps: programs: stdenv.lib.concatMapStrings
          (wrapMonkeysphere runtimeDeps)
          programs;
    in wrapPrograms [ gnupg ] [ "monkeysphere-authentication" "monkeysphere-host" ]
      + wrapPrograms [ ] [ "../share/monkeysphere/keytrans" "openpgp2ssh" ]
      + wrapPrograms [ lockfileProgs ] [ "monkeysphere" ];

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
