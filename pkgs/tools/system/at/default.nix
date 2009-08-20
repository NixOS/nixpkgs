{ fetchurl, stdenv, bison, flex, pam, ssmtp }:

stdenv.mkDerivation {
  name = "at-3.1.11";

  src = fetchurl {
    # Debian is apparently the last location where it can be found.
    url = mirror://debian/pool/main/a/at/at_3.1.11.orig.tar.gz;
    sha256 = "0n995h57x87xg10n8rkq06lynnb3syynfngwspfg91cp22cphycb";
  };

  patches = [ ./install.patch ];

  buildInputs =
    [ bison flex pam
      # `configure' and `atd' want the `sendmail' command.
      ssmtp
    ];

  preConfigure =
    ''
      export PATH="${ssmtp}/sbin:$PATH"

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
    license = "GPLv2+";
    homepage = http://packages.qa.debian.org/at;
  };
}
