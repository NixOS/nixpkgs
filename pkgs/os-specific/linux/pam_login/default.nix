{stdenv, fetchurl, pam}:
   
stdenv.mkDerivation {
  name = "pam_login-3.31";
   
  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/pam/pam_login/pam_login-3.31.tar.bz2;
    md5 = "15e34a48b0bc2ded5000e8d8780fc274";
  };

  buildInputs = [pam];
}
