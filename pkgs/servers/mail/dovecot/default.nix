{stdenv, fetchurl
  , openssl
  , pam
}:

stdenv.mkDerivation {
  name = "dovecot-1.0.3";

  buildInputs = [openssl pam];

  src = fetchurl {
    url = http://dovecot.org/releases/1.0/dovecot-1.0.3.tar.gz;
    sha256 = "14b3sbvj9xpm5mjwfavwrcwmzfdgian51ncspl8j83cd8j01jdjz";
  };
  
}
