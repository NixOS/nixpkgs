{stdenv, fetchurl, dovecot22, openssl}:

stdenv.mkDerivation rec {
  name = "dovecot-pigeonhole-${version}";
  version = "0.4.2";

  src = fetchurl {
    url = "http://www.rename-it.nl/dovecot/2.2/dovecot-2.2-pigeonhole-${version}.tar.gz";
    sha256 = "04rybb7ipsrhqapcqfr787n60lwd56gb33ylq7yqjr5q6xqg1684";
  };  

  buildInputs = [ dovecot22 openssl ];

  preConfigure = ''
    substituteInPlace src/managesieve/managesieve-settings.c --replace \
      ".executable = \"managesieve\"" \
      ".executable = \"$out/libexec/dovecot/managesieve\""
    substituteInPlace src/managesieve-login/managesieve-login-settings.c --replace \
      ".executable = \"managesieve-login\"" \
      ".executable = \"$out/libexec/dovecot/managesieve-login\""
  ''; 

  configureFlags = [ 
    "--with-dovecot=${dovecot22}/lib/dovecot"
    "--without-dovecot-install-dirs"
    "--with-moduledir=$(out)/lib/dovecot"
  ];  

  meta = with stdenv.lib; {
    homepage = http://pigeonhole.dovecot.org/;
    description = "A sieve plugin for the Dovecot IMAP server.";
    license = licenses.lgpl21;
    maintainers = [ maintainers.rickynils ];
  };  
}
