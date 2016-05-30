{ stdenv, lib, fetchurl, autoconf, automake, libtool, bison
, libasr, libevent, zlib, openssl, db, pam

# opensmtpd requires root for no reason to encrypt passwords, this patch fixes it
# see also https://github.com/OpenSMTPD/OpenSMTPD/issues/678
, unpriviledged_smtpctl_encrypt ? true

# This enables you to override the '+' character which typically separates the user from the tag in user+tag@domain.tld
, tag_char ? null
}:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "5.9.2p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib openssl db pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "07d7f1m5sxyz6mkk228rcm7fsf7350994ayvmhgph333q5rz48im";
  };

  patches = [ ./proc_path.diff ];

  postPatch = with builtins; with lib;
    optionalString (isString tag_char) ''
      sed -i -e "s,TAG_CHAR.*'+',TAG_CHAR '${tag_char}'," smtpd/smtpd-defines.h
    '' +
    optionalString unpriviledged_smtpctl_encrypt ''
      substituteInPlace smtpd/smtpctl.c --replace \
        'if (geteuid())' \
        'if (geteuid() != 0 && !(argc > 1 && !strcmp(argv[1], "encrypt")))'
    '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-mantype=doc"
    "--with-auth-pam"
    "--without-auth-bsdauth"
    "--with-path-socket=/run"
    "--with-user-smtpd=smtpd"
    "--with-user-queue=smtpq"
    "--with-group-queue=smtpq"
    "--with-path-CAfile=/etc/ssl/certs/ca-certificates.crt"
    "--with-libevent=${libevent.dev}"
    "--with-table-db"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    homepage = https://www.opensmtpd.org/;
    description = ''
      A free implementation of the server-side SMTP protocol as defined by
      RFC 5321, with some additional standard extensions
    '';
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rickynils obadz ];
  };
}
