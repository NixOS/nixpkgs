{stdenv, fetchurl, openldap}:
   
stdenv.mkDerivation {
  name = "nss_ldap-260";
   
  src = fetchurl {
    url = http://www.padl.com/download/nss_ldap-260.tar.gz;
    sha256 = "0kn022js39mqmy7g5ba911q46223vk7vcf51x28rbl86lp32zv4v";
  };

  preInstall = ''
    installFlagsArray=(INST_UID=$(id -u) INST_GID=$(id -g) LIBC_VERS=2.5 NSS_VERS=2 NSS_LDAP_PATH_CONF=$out/etc/ldap.conf)
    substituteInPlace Makefile \
      --replace '/usr$(libdir)' $TMPDIR \
      --replace 'install-data-local:' 'install-data-local-disabled:'
    mkdir -p $out/etc
  '';

  buildInputs = [openldap];
}
