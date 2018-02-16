{ lib, stdenv, fetchpatch, fetchurl, dovecot, openssl }:
let
  dovecotMajorMinor = lib.versions.majorMinor dovecot.version;
in stdenv.mkDerivation rec {
  pname = "dovecot-pigeonhole";
  version = "0.5.16";

  src = fetchurl {
    url = "https://pigeonhole.dovecot.org/releases/${dovecotMajorMinor}/dovecot-${dovecotMajorMinor}-pigeonhole-${version}.tar.gz";
    sha256 = "0f79qsiqnhaxn7mrrfcrnsjyv6357kzb7wa0chhfd69vwa06g8sw";
  };

  buildInputs = [ dovecot openssl ];

  patches = [
    # Fix mtime comparison so that scripts can be precompiled
    # https://github.com/dovecot/pigeonhole/pull/4
    (fetchpatch {
      name = "binary-mtime.patch";
      url = https://github.com/dovecot/pigeonhole/commit/3defbec146e195edad336a2c218f108462b0abd7.patch;
      sha256 = "09mvdw8gjzq9s2l759dz4aj9man8q1akvllsq2j1xa2qmwjfxarp";
    })
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
    homepage = "http://pigeonhole.dovecot.org/";
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ globin ajs124 ];
    platforms = platforms.unix;
  };
}
