{stdenv, fetchurl, pam, openldap}:
   
stdenv.mkDerivation {
  name = "pam_ldap-183";
   
  src = fetchurl {
    url = http://www.padl.com/download/pam_ldap-183.tar.gz;
    md5 = "c0ad81e9d9712ddc6599a6e7a1688778";
  };

  preInstall = "
    substituteInPlace Makefile --replace '-o root -g root' ''
  ";

  buildInputs = [pam openldap];
}
