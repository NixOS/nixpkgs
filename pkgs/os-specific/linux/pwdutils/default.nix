{stdenv, fetchurl, pam, openssl}:
   
stdenv.mkDerivation {
  name = "pwdutils-3.1.3";
   
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/utils/net/NIS/pwdutils-3.1.3.tar.bz2;
    md5 = "b18c601e282d8695cbb5ddd87eaa473c";
  };

  buildInputs = [pam openssl];

  configureFlags = "--disable-ldap";
}
