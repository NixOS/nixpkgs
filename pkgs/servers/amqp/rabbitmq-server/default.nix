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

stdenv.mkDerivation rec {
  pname = "rabbitmq-server";
  version = "3.10.7";

  # when updating, consider bumping elixir version in all-packages.nix
  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-tV4wWEGH8ZZQUFPbH+kGAerHyQY0Ff/4DbBsJH1pLrU=";
  };

  nativeBuildInputs = [ unzip xmlto docbook_xml_dtd_45 docbook_xsl zip rsync python3 ];
  buildInputs = [ erlang elixir libxml2 libxslt glibcLocales ]
    ++ lib.optionals stdenv.isDarwin [ AppKit Carbon Cocoa ];

  outputs = [ "out" "man" "doc" ];

  installFlags = [ "PREFIX=$(out)" "RMQ_ERLAPP_DIR=$(out)" ];
  installTargets = [ "install" "install-man" ];

  preBuild = ''
    export LANG=C.UTF-8 # fix elixir locale warning
  '';

  runtimePath = lib.makeBinPath ([
    erlang
    getconf # for getting memory limits
    socat
    procps
    gnused
    coreutils # used by helper scripts
  ] ++ lib.optionals stdenv.isLinux [ systemd ]); # for systemd unit activation check

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

  meta = with lib; {
    homepage = "https://www.rabbitmq.com/";
    description = "An implementation of the AMQP messaging protocol";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ turion ];
  };
}
