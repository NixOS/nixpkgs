{stdenv, fetchurl, pam, kerberos}:

stdenv.mkDerivation {
  name = "pam_krb5-2.3.11-1";

  src = fetchurl {
    url = https://fedorahosted.org/releases/p/a/pam_krb5/pam_krb5-2.3.11-1.tar.gz;
    sha256 = "1x6wgjzkfkx0h9a7wdgx0jwrdm15npbs79i510lk1n3fyx9lk4mq";
#    url = http://archives.eyrie.org/software/kerberos/pam-krb5-4.2.tar.gz;
#    sha256 = "0a0zyd4ddln8yf827qxbfqi1pryxnj0fykfz8lx6nxn2f9pqj1gv";
  };

  buildInputs = [pam kerberos];
  meta = {
#    homepage = "http://www.eyrie.org/~eagle/software/pam-krb5";
    homepage = "https://fedorahosted.org/pam_krb5/";
    description = "The pam_krb5 module allows PAM-aware applications to authenticate users by performing an AS exchange with a Kerberos KDC. It can optionally convert Kerberos 5 credentials to Kerberos IV credentials and/or use them to set up AFS tokens for a user's session.";
  };
}
