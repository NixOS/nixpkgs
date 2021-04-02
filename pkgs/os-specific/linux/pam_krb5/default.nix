{ lib, stdenv, fetchurl, pam, kerberos }:

stdenv.mkDerivation rec {
  name = "pam-krb5-4.10";

  src = fetchurl {
    url = "https://archives.eyrie.org/software/kerberos/${name}.tar.gz";
    sha256 = "09wzxd5zrj5bzqpb01qf148npj5k8hmd2bx2ij1qsy40hdxqyq79";
  };

  buildInputs = [ pam kerberos ];

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
