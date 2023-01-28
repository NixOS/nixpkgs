{ lib, stdenv, fetchurl, pam, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "pam-krb5";
  version = "4.11";

  src = fetchurl {
    url = "https://archives.eyrie.org/software/kerberos/pam-krb5-${version}.tar.gz";
    sha256 = "sha256-UDy+LLGv9L39o7z3+T+U+2ulLCbXCJNOcDmyGC/hCyA=";
  };

  buildInputs = [ pam libkrb5 ];

  meta = with lib; {
    homepage = "https://www.eyrie.org/~eagle/software/pam-krb5/";
    description = "PAM module allowing PAM-aware applications to authenticate users by performing an AS exchange with a Kerberos KDC";
    longDescription = ''
      pam_krb5 can optionally convert Kerberos 5 credentials to Kerberos IV
      credentials and/or use them to set up AFS tokens for a user's session.
    '';
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
