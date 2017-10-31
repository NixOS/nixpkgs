{ stdenv, fetchurl, erlang, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip, rsync

, AppKit, Carbon, Cocoa
}:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";

  version = "3.6.10";

  src = fetchurl {
    url = "https://www.rabbitmq.com/releases/rabbitmq-server/v${version}/${name}.tar.xz";
    sha256 = "0k1rhg1a51201b1hp6vaf4fk48hqz7m9hw55b8xnnyz2ld88jiqg";
  };

  buildInputs =
    [ erlang python libxml2 libxslt xmlto docbook_xml_dtd_45 docbook_xsl zip unzip rsync ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Carbon Cocoa ];

  preBuild =
    ''
      # Fix the "/usr/bin/env" in "calculate-relative".
      patchShebangs .
    '';

  installFlags = "PREFIX=$(out) RMQ_ERLAPP_DIR=$(out)";
  installTargets = "install install-man";

  postInstall =
    ''
      echo 'PATH=${erlang}/bin:''${PATH:+:}$PATH' >> $out/sbin/rabbitmq-env
    '';

  meta = {
    homepage = http://www.rabbitmq.com/;
    description = "An implementation of the AMQP messaging protocol";
    platforms = stdenv.lib.platforms.unix;
  };
}
