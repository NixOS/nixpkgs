args: with args;

stdenv.mkDerivation rec {
  name = "samba-3.0.28";

  src = fetchurl {
    url = "http://us1.samba.org/samba/ftp/stable/${name}.tar.gz";
    sha256 = "13nr4mvh6vxgl7nb94qnqx3njcyd10cf4ji18srlkizpp49r5byw";
  };

  buildInputs = [readline pam openldap kerberos popt iniparser libunwind fam];
  configureFlags = ''--with-pam --with-smbmount --datadir=$out/share
  --with-aio-support ''
  + (if (stdenv.gcc.libc != null) then "--with-libiconv=${stdenv.gcc.libc}" else "");
  postUnpack = "sourceRoot=\$sourceRoot/source";
  
  configFile = ./smb.conf;
  postInstall = ''
  rm -rf $out/var
  ln -s /var/samba $out/var
  cp ${configFile} $out/lib/smb.conf
  '';
}
