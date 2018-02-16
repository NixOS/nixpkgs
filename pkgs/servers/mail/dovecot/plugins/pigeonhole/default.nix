{ lib, stdenv, fetchpatch, fetchurl, dovecot, openssl }:
let
  dovecotMajorMinor = lib.versions.majorMinor dovecot.version;
in stdenv.mkDerivation rec {
  pname = "dovecot-pigeonhole";
  version = "0.5.21";

  src = fetchurl {
    url = "https://pigeonhole.dovecot.org/releases/${dovecotMajorMinor}/dovecot-${dovecotMajorMinor}-pigeonhole-${version}.tar.gz";
    hash = "sha256-HKcdJlkHZxIFinIDAojxULKwdrAwZFNHHFJhSY097Sc=";
  };

  buildInputs = [ dovecot openssl ];

  patches = [
    # Fix mtime comparison so that scripts can be precompiled
    ./0001-binary-mtime.patch
  ];

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
    homepage = "https://pigeonhole.dovecot.org/";
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ globin ajs124 ];
    platforms = platforms.unix;
  };
}
