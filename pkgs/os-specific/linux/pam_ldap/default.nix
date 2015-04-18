{stdenv, fetchurl, pam, openldap}:
   
stdenv.mkDerivation rec {
  name = "pam_ldap-183";
   
  src = fetchurl {
    url = "http://www.padl.com/download/${name}.tar.gz";
    sha256 = "1l0mlwvas9dnsfcgbszbzq3bzhdkibn1c3x15fczq3i82faf5g5a";
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
