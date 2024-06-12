{ lib
, fetchFromGitHub
, unixtools
, php82
, python3
, makeWrapper
, nixosTests
# run-time dependencies
, graphviz
, ipmitool
, libvirt
, monitoring-plugins
, mtr
, net-snmp
, nfdump
, nmap
, rrdtool
, system-sendmail
, whois
, dataDir ? "/var/lib/librenms", logDir ? "/var/log/librenms" }:


let
  phpPackage = php82.withExtensions ({ enabled, all }: enabled ++ [ all.memcached ]);
in phpPackage.buildComposerProject rec {
  pname = "librenms";
  version = "23.9.1";

  src = fetchFromGitHub {
    owner = "librenms";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-glcD9AhxkvMmGo/7/RhQFeOtvHJ4pSiEFxaAjeVrTaI=";
  };

  vendorHash = "sha256-s6vdGfM7Ehy1bbkB44EQaHBBvTkpVw9yxhVsc/O8dHc=";

  php = phpPackage;

  buildInputs = [
    unixtools.whereis
    (python3.withPackages (ps: with ps; [
      pymysql
      python-dotenv
      redis
      setuptools
      psutil
      command-runner
    ]))
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mv $out/share/php/librenms/* $out
    rm -r $out/share

    # This broken logic leads to bad settings being persisted in the database
    patch -p1 -d $out -i ${./broken-binary-paths.diff}

    substituteInPlace \
      $out/misc/config_definitions.json \
      --replace '"default": "/bin/ping",' '"default": "/run/wrappers/bin/ping",' \
      --replace '"default": "fping",' '"default": "/run/wrappers/bin/fping",' \
      --replace '"default": "fping6",' '"default": "/run/wrappers/bin/fping6",' \
      --replace '"default": "rrdtool",' '"default": "${rrdtool}/bin/rrdtool",' \
      --replace '"default": "snmpgetnext",' '"default": "${net-snmp}/bin/snmpgetnext",' \
      --replace '"default": "traceroute",' '"default": "/run/wrappers/bin/traceroute",' \
      --replace '"default": "/usr/bin/dot",' '"default": "${graphviz}/bin/dot",' \
      --replace '"default": "/usr/bin/ipmitool",' '"default": "${ipmitool}/bin/ipmitool",' \
      --replace '"default": "/usr/bin/mtr",' '"default": "${mtr}/bin/mtr",' \
      --replace '"default": "/usr/bin/nfdump",' '"default": "${nfdump}/bin/nfdump",' \
      --replace '"default": "/usr/bin/nmap",' '"default": "${nmap}/bin/nmap",' \
      --replace '"default": "/usr/bin/sfdp",' '"default": "${graphviz}/bin/sfdp",' \
      --replace '"default": "/usr/bin/snmpbulkwalk",' '"default": "${net-snmp}/bin/snmpbulkwalk",' \
      --replace '"default": "/usr/bin/snmpget",' '"default": "${net-snmp}/bin/snmpget",' \
      --replace '"default": "/usr/bin/snmptranslate",' '"default": "${net-snmp}/bin/snmptranslate",' \
      --replace '"default": "/usr/bin/snmpwalk",' '"default": "${net-snmp}/bin/snmpwalk",' \
      --replace '"default": "/usr/bin/virsh",' '"default": "${libvirt}/bin/virsh",' \
      --replace '"default": "/usr/bin/whois",' '"default": "${whois}/bin/whois",' \
      --replace '"default": "/usr/lib/nagios/plugins",' '"default": "${monitoring-plugins}/libexec",' \
      --replace '"default": "/usr/sbin/sendmail",' '"default": "${system-sendmail}/bin/sendmail",'

    substituteInPlace $out/LibreNMS/wrapper.py --replace '/usr/bin/env php' '${phpPackage}/bin/php'
    substituteInPlace $out/LibreNMS/__init__.py --replace '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'
    substituteInPlace $out/snmp-scan.py --replace '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'

    wrapProgram $out/daily.sh --prefix PATH : ${phpPackage}/bin

    rm -rf $out/logs $out/rrd $out/bootstrap/cache $out/storage $out/.env
    ln -s ${logDir} $out/logs
    ln -s ${dataDir}/config.php $out/config.php
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/rrd $out/rrd
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache

    runHook postInstall
  '';

  passthru = {
    phpPackage = phpPackage;
    tests.librenms = nixosTests.librenms;
  };

  meta = with lib; {
    description = "Auto-discovering PHP/MySQL/SNMP based network monitoring";
    homepage    = "https://www.librenms.org/";
    license     = licenses.gpl3Only;
    maintainers = teams.wdz.members;
    platforms   = platforms.linux;
  };
}
