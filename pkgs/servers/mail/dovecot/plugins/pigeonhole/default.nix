{ lib, stdenv, fetchurl, dovecot, openssl }:
let
  dovecotMajorMinor = lib.versions.majorMinor dovecot.version;
in stdenv.mkDerivation rec {
  pname = "dovecot-pigeonhole";
  version = "0.5.14";

  src = fetchurl {
    url = "https://pigeonhole.dovecot.org/releases/${dovecotMajorMinor}/dovecot-${dovecotMajorMinor}-pigeonhole-${version}.tar.gz";
    sha256 = "1lmjzz4kd90wbdslacybizd1dks4bhwmrx39lj8b19naldw0zjk8";
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

  meta = with lib; {
    homepage = "http://pigeonhole.dovecot.org/";
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.unix;
  };
}
