{ lib
, stdenv
, fetchurl
, erlang
, elixir
, python3
, libxml2
, libxslt
, xmlto
, docbook_xml_dtd_45
, docbook_xsl
, zip
, unzip
, rsync
, getconf
, socat
, procps
, coreutils
, gnused
, systemd
, glibcLocales
, AppKit
, Carbon
, Cocoa
, nixosTests
}:

let
  runtimePath = lib.makeBinPath ([
    erlang
    getconf # for getting memory limits
    socat
    procps
    gnused
    coreutils # used by helper scripts
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ systemd ]); # for systemd unit activation check
in

stdenv.mkDerivation rec {
  pname = "rabbitmq-server";
  version = "3.13.7";

  # when updating, consider bumping elixir version in all-packages.nix
  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${version}/${pname}-${version}.tar.xz";
    hash = "sha256-GDUyYudwhQSLrFXO21W3fwmH2tl2STF9gSuZsb3GZh0=";
  };

  nativeBuildInputs = [ unzip xmlto docbook_xml_dtd_45 docbook_xsl zip rsync python3 ];

  buildInputs = [ erlang elixir libxml2 libxslt glibcLocales ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ AppKit Carbon Cocoa ];

  outputs = [ "out" "man" "doc" ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "RMQ_ERLAPP_DIR=${placeholder "out"}"
  ];

  installTargets = [ "install" "install-man" ];

  preBuild = ''
    export LANG=C.UTF-8 # fix elixir locale warning
  '';

  postInstall = ''
    # rabbitmq-env calls to sed/coreutils, so provide everything early
    sed -i $out/sbin/rabbitmq-env -e '2s|^|PATH=${runtimePath}\''${PATH:+:}\$PATH/\n|'

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

  passthru.tests = {
    vm-test = nixosTests.rabbitmq;
  };

  meta = {
    homepage = "https://www.rabbitmq.com/";
    description = "Implementation of the AMQP messaging protocol";
    changelog = "https://github.com/rabbitmq/rabbitmq-server/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
