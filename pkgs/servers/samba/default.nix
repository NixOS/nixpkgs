args: with args;

stdenv.mkDerivation rec {
  name = "samba-3.0.30";

  src = fetchurl {
    url = http://www.samba.org/samba/ftp/stable/samba-3.0.30.tar.gz;
    sha256 = "0lzs53424fblg9g6z3nsan3dxi3bnn5h4zs31ji2bavai4xrsy51";
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
