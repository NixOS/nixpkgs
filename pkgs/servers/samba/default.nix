args: with args;

stdenv.mkDerivation rec {
  name = "samba-3.0.32";

  src = fetchurl {
    url = http://www.samba.org/samba/ftp/stable/samba-3.0.32.tar.gz;
    sha256 = "1mpc1w68c4sgpg6n58b6dqv0kzks6rjd9rxym72wbc2yx3h50zwa";
  };

  buildInputs = [readline pam openldap kerberos popt iniparser libunwind fam];

  preConfigure = "cd source";
  
  configureFlags = ''
    --with-pam
    --with-smbmount
    --with-aio-support
    ${if (stdenv.gcc.libc != null) then "--with-libiconv=${stdenv.gcc.libc}" else ""}
  '';
}
