{ fetchurl, stdenv, bison, flex, pam, ssmtp }:

stdenv.mkDerivation {
  name = "at-3.1.10.1";

  src = fetchurl {
    # Debian is apparently the last location where it can be found.
    url = mirror://debian/pool/main/a/at/at_3.1.10.2.tar.gz;
    sha256 = "03v96zil1xs15px26xmhxsfn7wx84a3zwpnwmp69hn5s911api1m";
  };

  patches = [ ./install.patch ];

  buildInputs = [ bison flex pam

                  # `configure' and `atd' want the `sendmail' command.
                  ssmtp ];

  configurePhase = ''
    export PATH="${ssmtp}/sbin:$PATH"
    ./configure --prefix=$out --with-etcdir=/etc/at \
                --with-jobdir=/var/spool/atjobs --with-atspool=/var/spool/atspool \
		--with-daemon_username=atd --with-daemon_groupname=atd
  '';

  meta = {
    description = ''The classical Unix `at' job scheduling command'';
    license = "GPLv2+";
    homepage = http://packages.qa.debian.org/at;
  };
}
