{ stdenv, fetchurl, erlang, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip }:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-3.0.3";

  src = fetchurl {
    url = "http://www.rabbitmq.com/releases/rabbitmq-server/v3.0.3/${name}.tar.gz";
    sha256 = "07mp57xvszdrlgw8rgn9r9dpa6vdqdjk7f1dyh6a9sdg8s9fby38";
  };

  buildInputs =
    [ erlang python libxml2 libxslt xmlto docbook_xml_dtd_45 docbook_xsl zip unzip ];

  preBuild =
    ''
      # Fix the "/usr/bin/env" in "calculate-relative".
      patchShebangs .
    '';

  installFlags = "TARGET_DIR=$(out)/libexec/rabbitmq SBIN_DIR=$(out)/sbin MAN_DIR=$(out)/share/man";

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
