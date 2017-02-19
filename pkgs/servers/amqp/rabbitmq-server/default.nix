{ stdenv, fetchurl, erlang, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip, rsync

, AppKit, Carbon, Cocoa
}:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";

  version = "3.6.6";

  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_6_6/rabbitmq-server-3.6.6.tar.xz";
    sha256 = "13mpnyfxd026w525rsnkcw0f8bcrkbzl7k9g8pnqmm3zyny8jmir";
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
    ''; # */

  meta = {
    homepage = http://www.rabbitmq.com/;
    description = "An implementation of the AMQP messaging protocol";
    platforms = stdenv.lib.platforms.unix;
  };
}
