{ stdenv, fetchurl, db4, glibc, openssl, cyrus_sasl
, coreutils, findutils, gnused, gnugrep
}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "postfix-2.2.11";
  
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/postfix-2.2.11.tar.gz;
    sha256 = "04hxpyd3h1f48fnppjwqqxbil13bcwidzpfkra2pgm7h42d9blq7";
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
    sed -e 's@PATH=.*@PATH=${coreutils}/bin:${findutils}/bin:${gnused}/bin:${gnugrep}/bin:$out/sbin@' -i $out/share/postfix/conf/post-install
    sed -e '2aPATH=${coreutils}/bin:${findutils}/bin:${gnused}/bin:${gnugrep}/bin:$out/sbin' -i $out/share/postfix/conf/postfix-script
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

    make makefiles CCARGS='-DUSE_TLS -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DHAS_DB -I${cyrus_sasl}/include/sasl' AUXLIBS='-lssl -lcrypto -lsasl2 -ldb'
  '';

  buildInputs = [db4 openssl cyrus_sasl];
  
  patches = [./postfix-2.2.9-db.patch ./postfix-2.2.9-lib.patch];
  
  inherit glibc;
}
