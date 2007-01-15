{stdenv, fetchurl, openldap}:
   
stdenv.mkDerivation {
  name = "nss_ldap-254";
   
  src = fetchurl {
    url = http://www.padl.com/download/nss_ldap-254.tar.gz;
    md5 = "00475b790d3aff3ccd40a1ab4520965e";
  };

  preInstall = "
    installFlagsArray=(INST_UID=$(id -u) INST_GID=$(id -g) LIBC_VERS=2.5 NSS_VERS=2)
    substituteInPlace Makefile --replace '/usr$(libdir)' $TMPDIR
    ensureDir $out/etc
  ";

  buildInputs = [openldap];
}
