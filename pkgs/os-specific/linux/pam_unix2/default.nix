{stdenv, fetchurl, pam, libxcrypt}:
   
stdenv.mkDerivation {
  name = "pam_unix2-2.1";
   
  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/pam/pam_unix2/pam_unix2-2.1.tar.bz2;
    md5 = "08d3bc1940897b5dfcbe2f51dd979ad0";
  };

  buildInputs = [pam libxcrypt];
}
