args: with args;

stdenv.mkDerivation rec {
  name = "samba-3.0.28a";

  src = fetchurl {
    url = http://us3.samba.org/samba/ftp/stable/samba-3.0.28a.tar.gz;
    sha256 = "1pnrh4qlapsqgdrzq4v5vxv622wcxghi5cp0n4f87c8pc2rfrjcx";
  };

  buildInputs = [readline pam openldap kerberos popt iniparser libunwind fam];

  preConfigure = "cd source";
  
  configureFlags = ''
    --with-pam
    --with-smbmount
    --with-aio-support
    ${if (stdenv.gcc.libc != null) then "--with-libiconv=${stdenv.gcc.libc}" else ""}
  '';


  #  --datadir=$out/share
    
  #postUnpack = "sourceRoot=\$sourceRoot/source";
  
  #configFile = ./smb.conf;
  
  #postInstall = ''
  #  rm -rf $out/var
  #  ln -s /var/samba $out/var
  #  cp ${configFile} $out/lib/smb.conf
  #'';
}
