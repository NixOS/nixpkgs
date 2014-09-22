{ fetchurl, stdenv, bison, flex, pam, sendmailPath ? "/var/setuid-wrappers/sendmail" }:

stdenv.mkDerivation {
  name = "at-3.1.15";

  src = fetchurl {
    # Debian is apparently the last location where it can be found.
    url = mirror://debian/pool/main/a/at/at_3.1.15.orig.tar.gz;
    sha256 = "1z7pgglr0zmwapb4sc1bdb3z0hgig1asyzqv4gs5xafmjd94za03";
  };

  patches = [ ./install.patch ];

  buildInputs =
    [ bison flex pam ];

  preConfigure =
    ''
      export SENDMAIL=${sendmailPath}
      # Purity: force atd.pid to be placed in /var/run regardless of
      # whether it exists now.
      substituteInPlace ./configure --replace "test -d /var/run" "true"
    '';

  configureFlags =
    ''
       --with-etcdir=/etc/at
       --with-jobdir=/var/spool/atjobs --with-atspool=/var/spool/atspool
       --with-daemon_username=atd --with-daemon_groupname=atd
    '';

  meta = {
    description = ''The classical Unix `at' job scheduling command'';
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://packages.qa.debian.org/at;
  };
}
