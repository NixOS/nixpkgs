{ stdenv, fetchurl, erlang, elixir, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip, rsync, getconf, socat
, AppKit, Carbon, Cocoa
}:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";

  version = "3.7.11";

  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${version}/${name}.tar.xz";
    sha256 = "04m9ikm7ywx63y68lf3rxds97nr9czdzg82c1m1f823m89kmpgi0";
  };

  buildInputs =
    [ erlang elixir python libxml2 libxslt xmlto docbook_xml_dtd_45 docbook_xsl zip unzip rsync ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Carbon Cocoa ];

  outputs = [ "out" "man" "doc" ];

  installFlags = "PREFIX=$(out) RMQ_ERLAPP_DIR=$(out)";
  installTargets = "install install-man";

  runtimePath = stdenv.lib.makeBinPath [getconf erlang socat];
  postInstall = ''
    echo 'PATH=${runtimePath}:''${PATH:+:}$PATH' >> $out/sbin/rabbitmq-env

    # we know exactly where rabbitmq is gonna be,
    # so we patch that into the env-script
    substituteInPlace $out/sbin/rabbitmq-env \
      --replace 'RABBITMQ_SCRIPTS_DIR=`dirname $SCRIPT_PATH`' \
                "RABBITMQ_SCRIPTS_DIR=$out/sbin"

    # there’s a few stray files that belong into share
    mkdir -p $doc/share/doc/rabbitmq-server
    mv $out/LICENSE* $doc/share/doc/rabbitmq-server

    # and an unecessarily copied INSTALL file
    rm $out/INSTALL
  '';

  meta = {
    homepage = http://www.rabbitmq.com/;
    description = "An implementation of the AMQP messaging protocol";
    license = stdenv.lib.licenses.mpl11;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ Profpatsch ];
  };
}
