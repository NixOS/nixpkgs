{stdenv, fetchurl, pam, libxcrypt}:
   
stdenv.mkDerivation {
  name = "pam_smbpass-2.2.8a";
   
  src = ./clr9p5ar0nc76ls15ifgf87wmlp3px2n-pam-smbpass-2.2.8a.tar;

  buildInputs = [pam libxcrypt];
}
