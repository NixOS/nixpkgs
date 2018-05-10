{ stdenv, fetchurl, pam, kerberos }:

stdenv.mkDerivation rec {
  name = "pam-krb5-4.8";

  src = fetchurl {
    url = "http://archives.eyrie.org/software/kerberos/${name}.tar.gz";
    sha256 = "0j96jfaxzkj1ifc3qxagjmaxvgda7ndqaaxx2ka018is9f5lbfrs";
  };

  buildInputs = [ pam kerberos ];

  meta = with stdenv.lib; {
    homepage = https://www.eyrie.org/~eagle/software/pam-krb5/;
    description = "PAM module allowing PAM-aware applications to authenticate users by performing an AS exchange with a Kerberos KDC";
    longDescription = ''
      pam_krb5 can optionally convert Kerberos 5 credentials to Kerberos IV
      credentials and/or use them to set up AFS tokens for a user's session.
    '';
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
  };
}
