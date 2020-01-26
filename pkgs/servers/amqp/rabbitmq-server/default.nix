{ stdenv, fetchurl, erlang, elixir, python, libxml2, libxslt, xmlto
, docbook_xml_dtd_45, docbook_xsl, zip, unzip, rsync, getconf, socat
, procps, coreutils, gnused, systemd, glibcLocales
, AppKit, Carbon, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "rabbitmq-server";

  version = "3.8.2";

  # when updating, consider bumping elixir version in all-packages.nix
  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "17gixahxass9n4d697my8sq4an51rw3cicb36fqvl8fbhnwjjrwc";
  };

  buildInputs =
    [ erlang elixir python libxml2 libxslt xmlto docbook_xml_dtd_45 docbook_xsl zip unzip rsync glibcLocales ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Carbon Cocoa ];

  outputs = [ "out" "man" "doc" ];

  installFlags = [ "PREFIX=$(out)" "RMQ_ERLAPP_DIR=$(out)" ];
  installTargets = [ "install" "install-man" ];

  preBuild = ''
    export LANG=C.UTF-8 # fix elixir locale warning
  '';

  runtimePath = stdenv.lib.makeBinPath [
    erlang
    getconf # for getting memory limits
    socat systemd procps # for systemd unit activation check
    gnused coreutils # used by helper scripts
  ];
  postInstall = ''
    # rabbitmq-env calls to sed/coreutils, so provide everything early
    sed -i $out/sbin/rabbitmq-env -e '2s|^|PATH=${runtimePath}\''${PATH:+:}\$PATH/\n|'

    # rabbitmq-server script uses `dirname` to get hold of a
    # rabbitmq-env, so let's provide this file directly. After that
    # point everything is OK - the PATH above will kick in
    substituteInPlace $out/sbin/rabbitmq-server \
      --replace '`dirname $0`/rabbitmq-env' \
                "$out/sbin/rabbitmq-env"

    # We know exactly where rabbitmq is gonna be, so we patch that into the env-script.
    # By doing it early we make sure that auto-detection for this will
    # never be executed (somewhere below in the script).
    sed -i $out/sbin/rabbitmq-env -e "2s|^|RABBITMQ_SCRIPTS_DIR=$out/sbin\n|"

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
