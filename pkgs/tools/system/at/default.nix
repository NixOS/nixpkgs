{ fetchurl, stdenv, bison, flex, pam, ssmtp }:

stdenv.mkDerivation {
  name = "at-3.1.14";

  src = fetchurl {
    # Debian is apparently the last location where it can be found.
    url = mirror://debian/pool/main/a/at/at_3.1.14.orig.tar.gz;
    sha256 = "cd092bf05d29c25b286f55a960ce8b8c3c5beb571d86ed8eb1dfb3b61291b3ae";
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
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://packages.qa.debian.org/at;
  };
}
