{ stdenv, fetchurl, dovecot, openssl }:

stdenv.mkDerivation rec {
  name = "dovecot-pigeonhole-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "http://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-${version}.tar.gz";
    sha256 = "0ivmaxic6cygfphvlrvy0xgggydm7j7kjv1ssfqbr08q4rcsmc73";
  };

  buildInputs = [ dovecot openssl ];

  preConfigure = ''
    substituteInPlace src/managesieve/managesieve-settings.c --replace \
      ".executable = \"managesieve\"" \
      ".executable = \"$out/libexec/dovecot/managesieve\""
    substituteInPlace src/managesieve-login/managesieve-login-settings.c --replace \
      ".executable = \"managesieve-login\"" \
      ".executable = \"$out/libexec/dovecot/managesieve-login\""
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--without-dovecot-install-dirs"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://pigeonhole.dovecot.org/;
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.unix;
  };
}
