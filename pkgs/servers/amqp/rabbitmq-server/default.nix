{ stdenv, fetchurl
, erlang, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip, rsync
, AppKit, Carbon, Cocoa
, getconf
}:

stdenv.mkDerivation rec {
  name = "rabbitmq-server-${version}";
  version = "3.6.15";

  src = fetchurl {
    url = "https://www.rabbitmq.com/releases/rabbitmq-server/v${version}/${name}.tar.xz";
    sha256 = "1zdmil657mhjmd20jv47s5dfpj2liqwvyg0zv2ky3akanfpgj98y";
  };

  buildInputs =
    [ erlang python libxml2 libxslt xmlto docbook_xml_dtd_45 docbook_xsl zip unzip rsync ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Carbon Cocoa ];

  outputs = [ "out" "man" "doc" ];

  postPatch = with stdenv.lib; ''
    # patch the path to getconf
    substituteInPlace deps/rabbit_common/src/vm_memory_monitor.erl \
      --replace "getconf PAGESIZE" "${getconf}/bin/getconf PAGESIZE"
  '';

  preBuild = ''
    # Fix the "/usr/bin/env" in "calculate-relative".
    patchShebangs .
  '';

  installFlags = "PREFIX=$(out) RMQ_ERLAPP_DIR=$(out)";
  installTargets = "install install-man";

  postInstall = ''
    echo 'PATH=${erlang}/bin:''${PATH:+:}$PATH' >> $out/sbin/rabbitmq-env

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

    # patched into a source file above;
    # needs to be explicitely passed to not be stripped by fixup
    mkdir -p $out/nix-support
    echo "${getconf}" > $out/nix-support/dont-strip-getconf

    '';

  meta = {
    homepage = http://www.rabbitmq.com/;
    description = "An implementation of the AMQP messaging protocol";
    license = stdenv.lib.licenses.mpl11;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ Profpatsch ];
  };
}
