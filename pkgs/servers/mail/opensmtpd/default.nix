{ stdenv, lib, fetchurl, fetchpatch, autoconf, automake, libtool, bison
, libasr, libevent, zlib, openssl, db, pam

# opensmtpd requires root for no reason to encrypt passwords, this patch fixes it
# see also https://github.com/OpenSMTPD/OpenSMTPD/issues/678
, unpriviledged_smtpctl_encrypt ? true

# Deprecated: use the subaddressing-delimiter in the config file going forward
, tag_char ? null
}:

if (tag_char != null)
then throw "opensmtpd: the tag_char argument is deprecated as it can now be specified at runtime via the 'subaddressing-delimiter' option of the configuration file"
else stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "6.0.3p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib openssl db pam ];

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "291881862888655565e8bbe3cfb743310f5dc0edb6fd28a889a9a547ad767a81";
  };

  patches = [
    ./proc_path.diff
    (fetchpatch {
      url = "https://github.com/OpenSMTPD/OpenSMTPD/commit/725ba4fa2ddf23bbcd1ff9ec92e86bbfaa6825c8.diff";
      sha256 = "19rla0b2r53jpdiz25fcza29c2msz6j6paivxhp9jcy1xl457dqa";
    })
  ];

  postPatch = with builtins; with lib;
    optionalString unpriviledged_smtpctl_encrypt ''
      substituteInPlace smtpd/smtpctl.c --replace \
        'if (geteuid())' \
        'if (geteuid() != 0 && !(argc > 1 && !strcmp(argv[1], "encrypt")))'
      substituteInPlace mk/smtpctl/Makefile.in --replace "chmod 2555" "chmod 0555"
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
