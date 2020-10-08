{ stdenv, fetchurl, dovecot, openssl }:

stdenv.mkDerivation rec {
  pname = "dovecot-pigeonhole";
  version = "0.5.11";

  src = fetchurl {
    url = "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-${version}.tar.gz";
    sha256 = "1w5mryv6izh1gv7davnl94rb0pvh5bxl2bydzbfla1b83x22m5qb";
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
    homepage = "http://pigeonhole.dovecot.org/";
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.unix;
  };
}
