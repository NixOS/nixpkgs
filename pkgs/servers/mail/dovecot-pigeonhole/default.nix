{stdenv, fetchurl, dovecot22, openssl}:

stdenv.mkDerivation rec {
  name = "dovecot-pigeonhole-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "http://www.rename-it.nl/dovecot/2.2/dovecot-2.2-pigeonhole-${version}.tar.gz";
    sha256 = "0vk9khwijl8qbjlm1q36a5dvpilrminp756n87c452kc3cfgc71n";
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
