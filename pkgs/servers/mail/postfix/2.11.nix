{ stdenv, fetchurl, makeWrapper, gnused, db, openssl, cyrus_sasl, coreutils
, findutils, gnugrep, gawk
}:

stdenv.mkDerivation rec {

  name = "postfix-${version}";

  version = "2.11.1";

  src = fetchurl {
    url = "ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/${name}.tar.gz";
    sha256 = "1ql9cifjcfhfi81lrf6zvk0r3spgcp01xwna16a7k9cm7fkrhzs8";
  };

  patches = [ ./postfix-2.11.0.patch ];

  buildInputs = [ makeWrapper gnused db openssl cyrus_sasl ];

  preBuild = ''
    sed -e '/^PATH=/d' -i postfix-install

    export command_directory=$out/sbin
    export config_directory=$out/etc/postfix
    export daemon_directory=$out/libexec/postfix
    export data_directory=/var/lib/postfix
    export html_directory=$out/share/postfix/doc/html
    export mailq_path=$out/bin/mailq
    export manpage_directory=$out/share/man
    export newaliases_path=$out/bin/newaliases
    export queue_directory=/var/spool/postfix
    export readme_directory=$out/share/postfix/doc
    export sendmail_path=$out/bin/sendmail

    make makefiles \
      CCARGS='-DUSE_TLS -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I${cyrus_sasl}/include/sasl' \
      AUXLIBS='-ldb -lnsl -lresolv -lsasl2 -lcrypto -lssl'
  '';

  installTargets = [ "non-interactive-package" ];

  installFlags = [ " install_root=$out " ];

  postInstall = ''
    mkdir -p $out
    mv -v ut/$out/* $out/
    sed -e '/^PATH=/d' -i $out/libexec/postfix/post-install
    wrapProgram $out/libexec/postfix/post-install \
      --prefix PATH ":" ${coreutils}/bin:${findutils}/bin:${gnugrep}/bin
    wrapProgram $out/libexec/postfix/postfix-script \
      --prefix PATH ":" ${coreutils}/bin:${findutils}/bin:${gnugrep}/bin:${gawk}/bin:${gnused}/bin
  '';

  meta = {
    homepage = "http://www.postfix.org/";
    description = "A fast, easy to administer, and secure mail server";
    license = stdenv.lib.licenses.bsdOriginal;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };

}
