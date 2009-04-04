{ stdenv, fetchurl, readline, pam, openldap, kerberos, popt
, iniparser, libunwind, fam, acl
}:

stdenv.mkDerivation rec {
  name = "samba-3.3.3";

  src = fetchurl {
    url = "http://us3.samba.org/samba/ftp/stable/${name}.tar.gz";
    sha256 = "08x3ng7ls5c1a95v7djx362i55wdlmnvarpr7rhng5bb55s9n5qn";
  };

  buildInputs = [readline pam openldap kerberos popt iniparser libunwind fam acl];

  preConfigure = "cd source";

  # Provide a dummy smb.conf to shut up programs like smbclient and smbspool.
  postInstall = ''
    touch $out/lib/smb.conf
  '';
  
  configureFlags = ''
    --with-pam
    --with-cifsmount
    --with-aio-support
    --with-pam_smbpass
    --disable-swat
    --enable-shared-libs
    ${if stdenv.gcc.libc != null then "--with-libiconv=${stdenv.gcc.libc}" else ""}
  '';
}
