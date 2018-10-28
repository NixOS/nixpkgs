{ stdenv, lib, fetchurl, fetchpatch, autoconf, automake, libtool, bison
, libasr, libevent, zlib, libressl, db, pam
}:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "6.4.0p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib libressl db pam ];

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "1qxxhnlsmpfh9v4azgl0634955r085gsic1c66jdll21bd5w2mq8";
  };

  patches = [
    ./proc_path.diff
    ./fix-build.diff # See https://github.com/OpenSMTPD/OpenSMTPD/pull/884
  ];

  # See https://github.com/OpenSMTPD/OpenSMTPD/issues/885 for the `sh bootstrap`
  # requirement
  postPatch = ''
    substituteInPlace smtpd/parse.y \
      --replace "/usr/libexec/" "$out/libexec/opensmtpd/"
    substituteInPlace mk/smtpctl/Makefile.am --replace "chgrp" "true"
    substituteInPlace mk/smtpctl/Makefile.am --replace "chmod 2555" "chmod 0555"
    sh bootstrap
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

  # See https://github.com/OpenSMTPD/OpenSMTPD/pull/884
  makeFlags = [ "CFLAGS=-ffunction-sections" "LDFLAGS=-Wl,--gc-sections" ];

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
    maintainers = with maintainers; [ rickynils obadz ekleog ];
  };
}
