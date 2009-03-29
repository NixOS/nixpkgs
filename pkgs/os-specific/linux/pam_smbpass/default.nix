{stdenv, fetchurl, pam, libxcrypt}:
   
stdenv.mkDerivation {
  name = "pam_smbpass-2.2.8a";
   
  src = ./pam-smbpass-2.2.8a.tar;

  buildInputs = [pam libxcrypt];
}
