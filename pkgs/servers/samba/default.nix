{ stdenv, fetchurl, readline, pam, openldap, kerberos, popt
, iniparser, libunwind, fam, acl
}:

stdenv.mkDerivation rec {
  name = "samba-3.2.7";

  src = fetchurl {
    url = http://us3.samba.org/samba/ftp/stable/samba-3.3.2.tar.gz;
    sha256 = "1b4fa9fbe7ccced6cca449c4b0b9fba65ffd2ad63b1f0bf2507e943281461477";
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
    --with-pam_smbpass
    ${if (stdenv.gcc.libc != null) then "--with-libiconv=${stdenv.gcc.libc}" else ""}
  '';
}
