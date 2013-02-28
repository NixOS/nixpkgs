{ stdenv, fetchurl, erlang, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip }:

stdenv.mkDerivation rec {
  version = "3.0.2";
  name = "rabbitmq-server-${version}";

  src = fetchurl {
    url = "http://www.rabbitmq.com/releases/rabbitmq-server/v${version}/${name}.tar.gz";
    sha256 = "1xcqv8jmpj768rl3219ksmpsm64imys7h9f3phvmpjfqdw6lnr9x";
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
