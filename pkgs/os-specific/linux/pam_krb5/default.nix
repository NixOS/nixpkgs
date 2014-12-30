{ stdenv, fetchurl, pam, kerberos }:

stdenv.mkDerivation rec {
  name = "pam_krb5-2.4.9";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/p/a/pam_krb5/${name}.tar.gz";
    sha256 = "0vcb35shzp406jvvz0pkgqm8qq1qzhgwmkl0nrm0wrrkqlr22rfb";
  };

  buildInputs = [ pam kerberos ];

  meta = with stdenv.lib; {
    homepage = https://fedorahosted.org/pam_krb5;
    description = "PAM module allowing PAM-aware applications to authenticate users by performing an AS exchange with a Kerberos KDC";
    longDescription = ''
      pam_krb5 can optionally convert Kerberos 5 credentials to Kerberos IV
      credentials and/or use them to set up AFS tokens for a user's session.
    '';
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington mornfall ];
  };
}
