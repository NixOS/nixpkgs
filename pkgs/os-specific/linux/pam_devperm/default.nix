{stdenv, fetchurl, pam}:
   
stdenv.mkDerivation {
  name = "pam_devperm-1.6";
   
  src = fetchurl {
    url = http://ftp.suse.com/pub/people/kukuk/pam/pam_devperm/pam_devperm-1.6.tar.bz2;
    sha256 = "0rvndh6yvcgmjnkqxv24pjy3ayy4p8r29w25xscwjfzqmrdyfbpw";
  };

  buildInputs = [pam];
}
