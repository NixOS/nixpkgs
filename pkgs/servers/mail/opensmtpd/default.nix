{ stdenv, lib, fetchurl, fetchpatch, autoconf, automake, libtool, bison
, libasr, libevent, zlib, openssl, db, pam

# opensmtpd requires root for no reason to encrypt passwords, this patch fixes it
# see also https://github.com/OpenSMTPD/OpenSMTPD/issues/678
, unpriviledged_smtpctl_encrypt ? true

# This enables you to override the '+' character which typically separates the user from the tag in user+tag@domain.tld
, tag_char ? null
}:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "6.0.2p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib openssl db pam ];

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "1b4h64w45hpmfq5721smhg4s0shs64gbcjqjpx3fbiw4hz8bdy9a";
  };

  patches = [
    ./proc_path.diff
    (fetchpatch {
      url = "https://github.com/Ekleog/OpenSMTPD/commit/80172fb0cd3c90c112bdd9c04fe05d84e6f562c6.diff";
      sha256 = "1xgfm0mydhv70ndn212fsvlwaf3axl3wdg2v1nqnrbyl919y5a10";
    })
  ];

  postPatch = with builtins; with lib;
    optionalString (isString tag_char) ''
      sed -i -e "s,TAG_CHAR.*'+',TAG_CHAR '${tag_char}'," smtpd/smtpd-defines.h
    '' +
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
