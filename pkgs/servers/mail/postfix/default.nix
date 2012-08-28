{ stdenv, fetchurl, db4, glibc, openssl, cyrus_sasl
, coreutils, findutils, gnused, gnugrep, bison, perl
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "postfix-2.8.12";

  src = fetchurl {
    url = "ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/${name}.tar.gz";
    sha256 = "11z07mjy53l1fnl7k4101yk4ilibgqr1164628mqcbmmr8bh2szl";
  };

  buildInputs = [db4 openssl cyrus_sasl bison perl];

  patches = [ ./postfix-2.2.9-db.patch  ./postfix-2.2.9-lib.patch ./db-linux3.patch ];

  postPatch = ''
    sed -i -e s,/usr/bin,/var/run/current-system/sw/bin, \
      -e s,/usr/sbin,/var/run/current-system/sw/sbin, \
      -e s,:/sbin,, src/util/sys_defs.h
  '';

  preBuild = ''
    export daemon_directory=$out/libexec/postfix
    export command_directory=$out/sbin
    export queue_directory=/var/spool/postfix
    export sendmail_path=$out/bin/sendmail
    export mailq_path=$out/bin/mailq
    export newaliases_path=$out/bin/newaliases
    export html_directory=$out/share/postfix/doc/html
    export manpage_directory=$out/share/man
    export sample_directory=$out/share/postfix/doc/samples
    export readme_directory=$out/share/postfix/doc

    make makefiles CCARGS='-DUSE_TLS -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I${cyrus_sasl}/include/sasl' AUXLIBS='-lssl -lcrypto -lsasl2 -ldb -lnsl'
  '';

  installPhase = ''
    sed -e '/^PATH=/d' -i postfix-install
    $SHELL postfix-install install_root=out -non-interactive -package

    mkdir -p $out
    mv -v "out$out/"* $out/

    mkdir -p $out/share/postfix
    mv conf $out/share/postfix/
    mv LICENSE TLS_LICENSE $out/share/postfix/

    sed -e 's@^PATH=.*@PATH=${coreutils}/bin:${findutils}/bin:${gnused}/bin:${gnugrep}/bin:'$out'/sbin@' -i $out/share/postfix/conf/post-install $out/libexec/postfix/post-install
    sed -e '2aPATH=${coreutils}/bin:${findutils}/bin:${gnused}/bin:${gnugrep}/bin:'$out'/sbin' -i $out/share/postfix/conf/postfix-script $out/libexec/postfix/postfix-script
    chmod a+x $out/share/postfix/conf/{postfix-script,post-install}
  '';

  inherit glibc;

  meta = {
    homepage = "http://www.postfix.org/";
    description = "a fast, easy to administer, and secure mail server";
    license = stdenv.lib.licenses.bsdOriginal;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
