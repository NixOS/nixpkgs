{ stdenv, fetchurl, erlang, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip

, AppKit, Carbon, Cocoa
}:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";

  version = "3.5.8";

  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_5_8/rabbitmq-server-3.5.8.tar.gz";
    sha256 = "0f373zxz15smb0jvfdfsbb924fl2qmp1z2jy3y50gv6b3xsdyqmr";
  };

  buildInputs =
    [ erlang python libxml2 libxslt xmlto docbook_xml_dtd_45 docbook_xsl zip unzip ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Carbon Cocoa ];

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
      echo 'PATH=${erlang}/bin:''${PATH:+:}$PATH' >> $out/sbin/rabbitmq-env
    ''; # */

  meta = {
    homepage = http://www.rabbitmq.com/;
    description = "An implementation of the AMQP messaging protocol";
    platforms = stdenv.lib.platforms.unix;
  };
}
