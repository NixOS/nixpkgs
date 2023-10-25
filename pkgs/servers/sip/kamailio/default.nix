{ callPackage
, fetchurl
, lib
, pkgs
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kamailio";
  version = "5.7.2";

  meta = {
    description = "Fast and flexible SIP server, proxy, SBC, and load balancer";
    homepage = "https://www.kamailio.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mawis ];
    platforms = lib.platforms.linux;
  };

  src = fetchurl {
    url = "https://www.kamailio.org/pub/kamailio/5.7.2/src/kamailio-${finalAttrs.version}_src.tar.gz";
    hash = "sha256-csmgZ9qNb6kg03N9mM1/ZsMh+Ay+EHbi1aOStCJQMSI=";
  };

  buildInputs = with pkgs; [
    bison
    flex
    gnugrep
    json_c.dev
    libevent.dev
    libxml2.dev
    mariadb-connector-c.dev
    pcre.dev
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
    which
  ];

  configurePhase = ''
    runHook preConfigure

    make PREFIX="$out" include_modules="db_mysql dialplan jsonrpcc json lcr presence presence_conference presence_dialoginfo presence_mwi presence_profile presence_reginfo presence_xml pua pua_bla pua_dialoginfo pua_json pua_reginfo pua_rpc pua_usrloc pua_xmpp regex rls xcap_client xcap_server" cfg

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    make MYSQLCFG=${pkgs.mariadb-connector-c.dev}/bin/mariadb_config all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make MYSQLCFG=${pkgs.mariadb-connector-c.dev}/bin/mariadb_config install
    echo 'MD5="${pkgs.coreutils}/bin/md5sum"' >> $out/etc/kamailio/kamctlrc
    echo 'AWK="${pkgs.gawk}/bin/awk"' >> $out/etc/kamailio/kamctlrc
    echo 'GDB="${pkgs.gdb}/bin/gdb"' >> $out/etc/kamailio/kamctlrc
    echo 'GREP="${pkgs.gnugrep}/bin/grep "' >> $out/etc/kamailio/kamctlrc
    echo 'EGREP="${pkgs.gnugrep}/bin/grep -E"' >> $out/etc/kamailio/kamctlrc
    echo 'SED="${pkgs.gnused}/bin/sed"' >> $out/etc/kamailio/kamctlrc
    echo 'LAST_LINE="${pkgs.coreutils}/bin/tail -n 1"' >> $out/etc/kamailio/kamctlrc
    echo 'EXPR="${pkgs.gnugrep}/bin/expr"' >> $out/etc/kamailio/kamctlrc

    runHook postInstall
  '';

  passthru.tests = {
    kamailio-bin = callPackage ./test-kamailio-bin {};
  };
})
