{ stdenv, fetchurl, pam, libxcrypt }:
   
stdenv.mkDerivation {
  name = "pam_unix2-2.6";
   
  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/pam/pam_unix2/pam_unix2-2.6.tar.bz2;
    sha256 = "067xnyd3q8ik73glxwyx1lydk4bgl78lzq44mnqqp4jrpnpd04ml";
  };

  buildInputs = [ pam ] ++ stdenv.lib.optional (!stdenv.isArm) libxcrypt;

  meta = {
    homepage = ftp://ftp.suse.com/pub/people/kukuk/pam/pam_unix2;
  };
}
