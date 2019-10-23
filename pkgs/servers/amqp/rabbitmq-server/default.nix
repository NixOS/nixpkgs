{ stdenv, fetchurl, erlang, elixir, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip, rsync, getconf, socat
, AppKit, Carbon, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "rabbitmq-server";

  version = "3.8.0";

  # when updating, consider bumping elixir version in all-packages.nix
  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "174ai8ihk50gwbqinxxxx5is6izvgmfca7skvvp4yk6fl8nbwm15";
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
