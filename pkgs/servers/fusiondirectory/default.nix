{ lib, stdenv, fetchurl, lndir, schema2ldif, scriptaculous,
prototypejs, smarty3, smarty3-i18n, gettext, makeWrapper,
perl, perlPackages, openldap, plugins ? []}: stdenv.mkDerivation rec {
  name = "fusiondirectory-${version}";
  version = "1.2.3";

  srcs = [
    (fetchurl {
      url = "https://repos.fusiondirectory.org/sources/fusiondirectory/fusiondirectory-${version}.tar.gz";
      sha256 = "19rmh0x6l28f40wsn3n54v7sgarz046b8fi2alh8b70f5asngqqk";
    })
    (fetchurl {
      url = "https://repos.fusiondirectory.org/sources/fusiondirectory/fusiondirectory-plugins-${version}.tar.gz";
      sha256 = "093arfsvai6mmlm6j36bdnfpdk5d64dzdigblmdix6k4l55ysbgm";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  unpackPhase = ''
    mkdir plugins fusiondirectory
    for src in $srcs; do
      case "$src" in
        *fusiondirectory-plugins*)
          tar xf "$src" -C plugins --strip-components=1
          ;;
        *)
          tar xf "$src" -C fusiondirectory --strip-components=1
          ;;
      esac
    done
  '';

  postPatch = ''
    # fusiondirectory-setup
    sed -i \
      -e 's:/usr/bin/perl:${perl}/bin/perl:g' \
      -e "s:/var/www/fusiondirectory:$out:g" \
      -e "s:/usr/share/php/smarty3:$out/share/smarty/Smarty.class.php:g" \
      -e "s:/var/cache/fusiondirectory:$out/share/cache:g" \
      -e 's:"msgcat:"${gettext}/bin/msgcat:g' \
      -e 's:"msgfmt:"${gettext}/bin/msgfmt:g' \
      -e '/use Term::ReadKey;/d' \
      -e '/as root/d' \
      fusiondirectory/contrib/bin/fusiondirectory-setup

    # fusiondirectory-insert-schema
    sed -i \
      -e 's:/usr/bin/perl:${perl}/bin/perl:g' \
      -e 's:ldap-schema-manager:${schema2ldif}/bin/ldap-schema-manager:g' \
      -e "s:/etc/ldap/schema/fusiondirectory:$out/etc/schema:g" \
      fusiondirectory/contrib/bin/fusiondirectory-insert-schema

    # Path to ldapsearch
    sed -i \
      -e 's: = "ldapsearch: = "${openldap}/bin/ldapsearch:g' \
      fusiondirectory/include/class_ldap.inc

    # Path to fusiondirectory.auth
    sed -i "s:CACHE_DIR:'/var/spool/fusiondirectory/':g" fusiondirectory/setup/class_setupStepWelcome.inc

    # Plugin installation
    sed -i 's/@@plugins@@/"${lib.concatStringsSep "\", \"" plugins}"/g' fusiondirectory/contrib/bin/fusiondirectory-setup
  '';

  patches = [ ./setup-plugins.patch ];

  installPhase = ''
    # Core
    mkdir -p $out
    cp -r fusiondirectory/{html,ihtml,include,locale,plugins,setup} $out

    # Binaries
    install -Dm755 -t $out/bin fusiondirectory/contrib/bin/fusiondirectory-setup
    install -Dm755 -t $out/bin fusiondirectory/contrib/bin/fusiondirectory-insert-schema
    wrapProgram $out/bin/fusiondirectory-setup \
      --set PERL5LIB "${perlPackages.makePerlPath (with perlPackages; [ PathClass NetLDAP
      MIMEBase64 CryptPasswdMD5 CryptCBC FileCopyRecursive ArchiveExtract XMLTwig DigestSHA1
      DataDumper ConvertASN1 XMLParser ])}"

    # man pages
    mkdir -p $out/share/man/man{1,5}
    gzip -c fusiondirectory/contrib/man/fusiondirectory.conf.5 > $out/share/man/man5/fusiondirectory.conf.5.gz
    gzip -c fusiondirectory/contrib/man/fusiondirectory-setup.1 > $out/share/man/man1/fusiondirectory-setup.1.gz
    gzip -c fusiondirectory/contrib/man/fusiondirectory-insert-schema.1 > $out/share/man/man1/fusiondirectory-insert-schema.1.gz

    # Schemas
    install -Dm644 -t $out/etc/schema fusiondirectory/contrib/openldap/* plugins/*/contrib/openldap/*

    # smarty
    # Cannot symlinks because plugin resolving would use the wrong directory
    cp -ra ${smarty3}/ $out/share/smarty/
    chmod 755 $out/share/smarty/plugins

    # smarty plugins
    install -m644 -t $out/share/smarty/plugins fusiondirectory/contrib/smarty/plugins/*
    ln -s ${smarty3-i18n}/block.t.php $out/share/smarty/plugins/

    # JavaScript libraries
    ln -s -t $out/html/include ${scriptaculous}/*
    ln -s ${prototypejs} $out/html/include/prototype.js

    # Cache
    mkdir -p $out/share/cache $out/share/cache/template $out/share/cache/locale
    ln -s /var/cache/fusiondirectory/tmp $out/share/cache/tmp
    ln -s /var/cache/fusiondirectory/fai $out/share/cache/fai
    ln -s /var/cache/fusiondirectory/supann $out/share/cache/supann
    install -Dm644 -t $out/share/cache/template fusiondirectory/contrib/fusiondirectory.conf

    # Plugins and caches
    $out/bin/fusiondirectory-setup --write-vars --install-plugins
  '';

  meta = with stdenv.lib; {
    description = "Provides a solution to daily management of data stored in an LDAP directory";
    longDescription = ''
      FusionDirectory provides a solution to daily management of data stored in an LDAP directory.
      Becoming the cornerstone of the information system, the corporate directory becomes more
      complex offering more data and managing more infrastructure services.

      This interface is simple and can be used to delegate fully or partly the data management
      to non-specialists.
    '';
    license = licenses.gpl2;
    homepage = "https://www.fusiondirectory.org/";
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
