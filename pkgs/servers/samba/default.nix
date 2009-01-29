{ stdenv, fetchurl, readline, pam, openldap, kerberos, popt
, iniparser, libunwind, fam, acl
}:

stdenv.mkDerivation rec {
  name = "samba-3.2.7";

  src = fetchurl {
    url = http://us3.samba.org/samba/ftp/stable/samba-3.2.7.tar.gz;
    sha256 = "18q4q1ay9dsk3djl1s2ibj51n8c111y05h5dsc2ssl2wg32vhasg";
  };

  buildInputs = [readline pam openldap kerberos popt iniparser libunwind fam acl];

  preConfigure = "cd source";

  # Provide a dummy smb.conf to shut up programs like smbclient and smbspool.
  postInstall = ''
    touch $out/lib/smb.conf
  '';
  
  configureFlags = ''
    --with-pam
    --with-smbmount
    --with-aio-support
    ${if (stdenv.gcc.libc != null) then "--with-libiconv=${stdenv.gcc.libc}" else ""}
  '';
}
