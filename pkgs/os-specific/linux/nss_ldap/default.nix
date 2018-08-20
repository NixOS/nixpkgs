{stdenv, fetchurl, openldap, perl}:

stdenv.mkDerivation {
  name = "nss_ldap-265";

  src = fetchurl {
    url = http://www.padl.com/download/nss_ldap-265.tar.gz;
    sha256 = "1a16q9p97d2blrj0h6vl1xr7dg7i4s8x8namipr79mshby84vdbp";
  };

  preConfigure = ''
    patchShebangs ./vers_string
    sed -i s,vers_string,./vers_string, Makefile*
  '';

  patches = [ ./crashes.patch ];

  postPatch = ''
    patch -p0 < ${./nss_ldap-265-glibc-2.16.patch}
  '';

  preInstall = ''
    installFlagsArray=(INST_UID=$(id -u) INST_GID=$(id -g) LIBC_VERS=2.5 NSS_VERS=2 NSS_LDAP_PATH_CONF=$out/etc/ldap.conf)
    substituteInPlace Makefile \
      --replace '/usr$(libdir)' $TMPDIR \
      --replace 'install-data-local:' 'install-data-local-disabled:'
    mkdir -p $out/etc
  '';

  buildInputs = [ openldap perl ];

  meta = with stdenv.lib; {
    description = "LDAP module for the Solaris Nameservice Switch (NSS)";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
