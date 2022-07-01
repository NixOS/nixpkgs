{ stdenv, lib, fetchurl, makeWrapper
, gawk, gnused, gnugrep, coreutils, which
, perlPackages
, withMySQL ? false, zlib, mysql57
, withPgSQL ? false, postgresql
, withSQLite ? false, sqlite
, withDB ? false, db
}:

let
  drivers = lib.concatStringsSep ","
            ([ "hash_drv" ]
             ++ lib.optional withMySQL "mysql_drv"
             ++ lib.optional withPgSQL "pgsql_drv"
             ++ lib.optional withSQLite "sqlite3_drv"
             ++ lib.optional withDB "libdb4_drv"
            );
  maintenancePath = lib.makeBinPath [ gawk gnused gnugrep coreutils which ];

in stdenv.mkDerivation rec {
  pname = "dspam";
  version = "3.10.2";

  src = fetchurl {
    url = "mirror://sourceforge/dspam/dspam/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1acklnxn1wvc7abn31l3qdj8q6k13s51k5gv86vka7q20jb5cxmf";
  };

  buildInputs = [ perlPackages.perl ]
                ++ lib.optionals withMySQL [ zlib mysql57.connector-c ]
                ++ lib.optional withPgSQL postgresql
                ++ lib.optional withSQLite sqlite
                ++ lib.optional withDB db;
  nativeBuildInputs = [ makeWrapper ];

  configureFlags = [
    "--with-storage-driver=${drivers}"
    "--sysconfdir=/etc/dspam"
    "--localstatedir=/var"
    "--with-dspam-home=/var/lib/dspam"
    "--with-logdir=/var/log/dspam"
    "--with-logfile=/var/log/dspam/dspam.log"

    "--enable-daemon"
    "--enable-clamav"
    "--enable-syslog"
    "--enable-large-scale"
    "--enable-virtual-users"
    "--enable-split-configuration"
    "--enable-preferences-extension"
    "--enable-long-usernames"
    "--enable-external-lookup"
  ] ++ lib.optional withMySQL "--with-mysql-includes=${mysql57.connector-c}/include/mysql"
    ++ lib.optional withPgSQL "--with-pgsql-libraries=${postgresql.lib}/lib";

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: .libs/hash_drv.o:/build/dspam-3.10.2/src/util.h:96: multiple definition of `verified_user';
  #     .libs/libdspam.o:/build/dspam-3.10.2/src/util.h:96: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  # Lots of things are hardwired to paths like sysconfdir. That's why we install with both "prefix" and "DESTDIR"
  # and fix directory structure manually after that.
  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/$out/* $out
    rm -rf $out/$(echo "$out" | cut -d "/" -f2)
    rm -rf $out/var

    wrapProgram $out/bin/dspam_notify \
      --set PERL5LIB "${perlPackages.makePerlPath [ perlPackages.libnet ]}"

    # Install SQL scripts
    mkdir -p $out/share/dspam/sql
    # MySQL
    cp src/tools.mysql_drv/mysql_*.sql $out/share/dspam/sql
    for i in src/tools.mysql_drv/{purge*.sql,virtual*.sql}; do
      cp "$i" $out/share/dspam/sql/mysql_$(basename "$i")
    done
    # PostgreSQL
    cp src/tools.pgsql_drv/pgsql_*.sql $out/share/dspam/sql
    for i in src/tools.pgsql_drv/{purge*.sql,virtual*.sql}; do
      cp "$i" $out/share/dspam/sql/pgsql_$(basename "$i")
    done
    # SQLite
    for i in src/tools.sqlite_drv/purge*.sql; do
      cp "$i" $out/share/dspam/sql/sqlite_$(basename "$i")
    done

    # Install maintenance script
    install -Dm755 contrib/dspam_maintenance/dspam_maintenance.sh $out/bin/dspam_maintenance
    sed -i \
      -e "2iexport PATH=$out/bin:${maintenancePath}:\$PATH" \
      -e 's,/usr/[a-z0-9/]*,,g' \
      -e 's,^DSPAM_CONFIGDIR=.*,DSPAM_CONFIGDIR=/etc/dspam,' \
      -e "s,^DSPAM_HOMEDIR=.*,DSPAM_HOMEDIR=/var/lib/dspam," \
      -e "s,^DSPAM_PURGE_SCRIPT_DIR=.*,DSPAM_PURGE_SCRIPT_DIR=$out/share/dspam/sql," \
      -e "s,^DSPAM_BIN_DIR=.*,DSPAM_BIN_DIR=$out/bin," \
      -e "s,^MYSQL_BIN_DIR=.*,MYSQL_BIN_DIR=/run/current-system/sw/bin," \
      -e "s,^PGSQL_BIN_DIR=.*,PGSQL_BIN_DIR=/run/current-system/sw/bin," \
      -e "s,^SQLITE_BIN_DIR=.*,SQLITE_BIN_DIR=/run/current-system/sw/bin," \
      -e "s,^SQLITE3_BIN_DIR=.*,SQLITE3_BIN_DIR=/run/current-system/sw/bin," \
      -e 's,^DSPAM_CRON_LOCKFILE=.*,DSPAM_CRON_LOCKFILE=/run/dspam/dspam_maintenance.pid,' \
      $out/bin/dspam_maintenance
  '';

  meta = with lib; {
    homepage = "http://dspam.sourceforge.net/";
    description = "Community Driven Antispam Filter";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
