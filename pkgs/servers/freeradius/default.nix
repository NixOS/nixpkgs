{ stdenv, fetchurl, autoreconfHook, talloc, openssl ? null }:

## TODO: include ldap optionally
## TODO: include sqlite optionally
## TODO: include mysql optionally

stdenv.mkDerivation rec {
  name = "freeradius-${version}";
  version = "3.0.11";

  buildInputs = [
    autoreconfHook
    talloc
    openssl
  ];

  configureFlags = [
     "--sysconfdir=/etc"
     "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
   ];

  src = fetchurl {
    url = "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-${version}.tar.gz";
    sha256 = "0naxw9b060rbp4409904j6nr2zwl6wbjrbq1839xrwhmaf8p4yxr";
  };

  meta = with stdenv.lib; {
    homepage = http://freeradius.org/;
    description = "A modular, high performance free RADIUS suite";
    license = stdenv.lib.licenses.gpl2;
  };

}

