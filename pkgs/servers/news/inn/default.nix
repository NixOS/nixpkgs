{ lib
, stdenv
, fetchurl
, bison
, flex
, perl
, libcanlock
, sqlite
, pkg-config
, systemd
, python3
, gnupg
, openssl
, cyrus_sasl
, krb5
, perlPackages
, pam
, uucp
, db62
, wget
, ncftp
, sendmailPath ? "/run/wrappers/bin/sendmail"
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, zlib
, withCanlock ? true
, withKrb5 ? true
, withOpenSSL ? true
, withPerl ? true
, withPython3 ? true
, withPam ? stdenv.isLinux
, withBdb ? true
, withSASL ? true
, withSQLite3 ? true
, withZlib ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "inn";
  version = "2.7.1";

  src = fetchurl {
    url = "https://downloads.isc.org/isc/inn/inn-${finalAttrs.version}.tar.gz";
    hash = "sha256-6ODKd/YPlQ8XR8gvcml918Jpe8aRtG91YgViVXldk/Q=";
  };

  configureFlags = [
    "--with-sendmail=${sendmailPath}"
    "--enable-largefiles"
  ]
  ++ (lib.optional withKrb5 "--with-krb5")
  ++ (lib.optional withPerl "--with-perl")
  ++ (lib.optional withPython3 "--with-python")
  ++ (lib.optional withSASL "--with-sasl");

  propagatedBuildInputs = builtins.attrValues {
    inherit (perlPackages) MIMETools GD Encode DBDSQLite;
  };

  buildInputs = [
    bison
    flex
    perl
    pkg-config
    python3
    gnupg
    cyrus_sasl
    krb5
    uucp
    wget
    ncftp
  ]
  ++ (lib.optional withBdb db62)
  ++ (lib.optional withPam pam)
  ++ (lib.optional withSQLite3 sqlite)
  ++ (lib.optional withZlib zlib)
  ++ (lib.optional withCanlock libcanlock)
  ++ (lib.optional withOpenSSL openssl)
  ++ (lib.optional withSystemd systemd);

  preInstall = ''
    export CHOWNPROG=set CHGRPPROG=set
  '';

  meta = {
    homepage = "https://www.eyrie.org/~eagle/software/inn/";
    description = "INN (InterNetNews) is a full-featured and flexible news server package";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ne9z ];
  };
})
