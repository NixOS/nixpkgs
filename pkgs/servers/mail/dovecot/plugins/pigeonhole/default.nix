{ stdenv, fetchurl, dovecot, openssl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "dovecot-pigeonhole-${version}";
  version = "0.5.7.2";

  src = fetchurl {
    url = "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-${version}.tar.gz";
    sha256 = "1c0ijjmdskxydmvfk8ixxgg8ndnxx1smvycbp7jjd895a9f0r7fm";
  };

  buildInputs = [ dovecot openssl ];

  patches = [
    (fetchpatch {
      name = "CVE-2019-11500-1.patch";
      url = https://github.com/dovecot/pigeonhole/commit/7ce9990a5e6ba59e89b7fe1c07f574279aed922c.patch;
      sha256 = "07l4m2wkqn910zb8d477q6asryfqzhbhxl4fl0w89s763maiam9v";
    })
    (fetchpatch {
      name = "CVE-2019-11500-2.patch";
      url = https://github.com/dovecot/pigeonhole/commit/4a299840cdb51f61f8d1ebc0210b19c40dfbc1cc.patch;
      sha256 = "1p7jl3fcxr63yrgj5m11sbmbfnibrx5v9aifscn1wq858jnn8myf";
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

  meta = with stdenv.lib; {
    homepage = http://pigeonhole.dovecot.org/;
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.unix;
  };
}
