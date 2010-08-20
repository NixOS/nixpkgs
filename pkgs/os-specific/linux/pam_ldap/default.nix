{stdenv, fetchurl, pam, openldap}:
   
stdenv.mkDerivation rec {
  name = "pam_ldap-183";
   
  src = fetchurl {
    url = "http://www.padl.com/download/${name}.tar.gz";
    md5 = "c0ad81e9d9712ddc6599a6e7a1688778";
  };

  preInstall = "
    substituteInPlace Makefile --replace '-o root -g root' ''
  ";

  buildInputs = [pam openldap];

  meta = {
    homepage = http://www.padl.com/OSS/pam_ldap.html;
    description = "LDAP backend for PAM";
    longDescription = ''
      The pam_ldap module provides the means for Solaris and Linux servers and
      workstations to authenticate against LDAP directories, and to change their
      passwords in the directory.'';
    license = "LGPL";
    inherit (pam.meta) platforms;
  };
}
