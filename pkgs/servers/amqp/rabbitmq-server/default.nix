{ stdenv, fetchurl, erlang, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip }:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";

  version = "3.2.4";

  src = fetchurl {
    url = "http://www.rabbitmq.com/releases/rabbitmq-server/v${version}/${name}.tar.gz";
    sha256 = "17rvqhzcb7rscp228vmgixk0rsqi42m820jzxj9g5wid6qmzjc59";
  };

  buildInputs =
    [ erlang python libxml2 libxslt xmlto docbook_xml_dtd_45 docbook_xsl zip unzip ];

  preBuild =
    ''
      # Fix the "/usr/bin/env" in "calculate-relative".
      patchShebangs .
    '';

  installFlags = "TARGET_DIR=$(out)/libexec/rabbitmq SBIN_DIR=$(out)/sbin MAN_DIR=$(out)/share/man DOC_INSTALL_DIR=$(out)/share/doc";

  preInstall =
    ''
      sed -i \
        -e 's|SYS_PREFIX=|SYS_PREFIX=''${SYS_PREFIX-''${HOME}/.rabbitmq/${version}}|' \
        -e 's|CONF_ENV_FILE=''${SYS_PREFIX}\(.*\)|CONF_ENV_FILE=\1|' \
        scripts/rabbitmq-defaults
    '';

  postInstall =
    ''
      echo 'PATH=${erlang}/bin:${PATH:+:}$PATH' >> $out/sbin/rabbitmq-env
    ''; # */

  meta = {
    homepage = http://www.rabbitmq.com/;
    description = "An implementation of the AMQP messaging protocol";
    platforms = stdenv.lib.platforms.linux;
  };
}
