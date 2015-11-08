{ stdenv, fetchurl, makeWrapper, gnused, db, openssl, cyrus_sasl, coreutils
, findutils, gnugrep, gawk, icu
}:

stdenv.mkDerivation rec {

  name = "postfix-${version}";

  version = "3.0.3";

  src = fetchurl {
    url = "ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/${name}.tar.gz";
    sha256 = "00mc12k5p1zlrlqcf33vh5zizaqr5ai8q78dwv69smjh6kn4c7j0";
  };

  buildInputs = [ makeWrapper gnused db openssl cyrus_sasl icu ];

  preBuild = ''
    sed -e '/^PATH=/d' -i postfix-install

    export command_directory=$out/sbin
    export config_directory=/etc/postfix
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
      CCARGS='-DUSE_TLS -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I${cyrus_sasl}/include/sasl \
              -DHAS_DB_BYPASS_MAKEDEFS_CHECK \
              -fPIE -fstack-protector-all --param ssp-buffer-size=4 -O2 -D_FORTIFY_SOURCE=2' \
      AUXLIBS='-ldb -lnsl -lresolv -lsasl2 -lcrypto -lssl -pie -Wl,-z,relro,-z,now'
  '';

  installTargets = [ "non-interactive-package" ];

  installFlags = [ " install_root=installdir " ];

  postInstall = ''
    mkdir -p $out
    mv -v installdir/$out/* $out/
    mv -v installdir/etc $out/etc
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
