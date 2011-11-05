{ stdenv, fetchurl, db4, glibc, openssl, cyrus_sasl
, coreutils, findutils, gnused, gnugrep, bison, perl
}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "postfix-2.8.6";
  
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/postfix-2.8.6.tar.gz;
    sha256 = "1rfsfhna5hy5lc6hkg1zc2862pdc5c1y9z6aiy8rinlmzrfplhlb";
  };

  installTargets = ["non-interactive-package"];
  
  installFlags = [" install_root=$out "];
  
  preInstall = ''
    sed -e '/^PATH=/d' -i postfix-install
  '';
  
  postInstall = ''
    ensureDir $out
    mv ut/$out/* $out/

    mkdir $out/share/postfix/conf
    cp conf/* $out/share/postfix/conf
    sed -e 's@PATH=.*@PATH=${coreutils}/bin:${findutils}/bin:${gnused}/bin:${gnugrep}/bin:'$out'/sbin@' -i $out/share/postfix/conf/post-install $out/libexec/postfix/post-install
    sed -e '2aPATH=${coreutils}/bin:${findutils}/bin:${gnused}/bin:${gnugrep}/bin:'$out'/sbin' -i $out/share/postfix/conf/postfix-script $out/libexec/postfix/postfix-script
    chmod a+x $out/share/postfix/conf/{postfix-script,post-install}
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

  buildInputs = [db4 openssl cyrus_sasl bison perl];
  
  patches = [ ./postfix-2.2.9-db.patch  ./postfix-2.2.9-lib.patch ./db-linux3.patch ];

  postPatch = ''
    sed -i -e s,/usr/bin,/var/run/current-system/sw/bin, \
      -e s,/usr/sbin,/var/run/current-system/sw/sbin, \
      -e s,:/sbin,, src/util/sys_defs.h
  '';
  
  inherit glibc;
}
