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
  version = "24.8.0";

  src = fetchFromGitHub {
    owner = "librenms";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-K4aHFMTHOLkrep2XtcilbaVsQrqXvuQmYZBl3+iG6kg=";
  };

  vendorHash = "sha256-jJa4wQJQyeV6/ZkbZCxwyNi3AmPMtnUpGa4VQzkIKy4=";

  php = phpPackage;

  buildInputs = [
    graphviz
    ipmitool
    libvirt
    monitoring-plugins
    mtr
    net-snmp
    nfdump
    nmap
    rrdtool
    system-sendmail
    unixtools.whereis
    whois
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
      --replace-fail '"default": "/bin/ping",' '"default": "/run/wrappers/bin/ping",' \
      --replace-fail '"default": "fping",' '"default": "/run/wrappers/bin/fping",' \
      --replace-fail '"default": "fping6",' '"default": "/run/wrappers/bin/fping6",' \
      --replace-fail '"default": "rrdtool",' '"default": "${rrdtool}/bin/rrdtool",' \
      --replace-fail '"default": "snmpgetnext",' '"default": "${net-snmp}/bin/snmpgetnext",' \
      --replace-fail '"default": "traceroute",' '"default": "/run/wrappers/bin/traceroute",' \
      --replace-fail '"default": "/usr/bin/dot",' '"default": "${graphviz}/bin/dot",' \
      --replace-fail '"default": "/usr/bin/ipmitool",' '"default": "${ipmitool}/bin/ipmitool",' \
      --replace-fail '"default": "/usr/bin/mtr",' '"default": "${mtr}/bin/mtr",' \
      --replace-fail '"default": "/usr/bin/nfdump",' '"default": "${nfdump}/bin/nfdump",' \
      --replace-fail '"default": "/usr/bin/nmap",' '"default": "${nmap}/bin/nmap",' \
      --replace-fail '"default": "/usr/bin/sfdp",' '"default": "${graphviz}/bin/sfdp",' \
      --replace-fail '"default": "/usr/bin/snmpbulkwalk",' '"default": "${net-snmp}/bin/snmpbulkwalk",' \
      --replace-fail '"default": "/usr/bin/snmpget",' '"default": "${net-snmp}/bin/snmpget",' \
      --replace-fail '"default": "/usr/bin/snmptranslate",' '"default": "${net-snmp}/bin/snmptranslate",' \
      --replace-fail '"default": "/usr/bin/snmpwalk",' '"default": "${net-snmp}/bin/snmpwalk",' \
      --replace-fail '"default": "/usr/bin/virsh",' '"default": "${libvirt}/bin/virsh",' \
      --replace-fail '"default": "/usr/bin/whois",' '"default": "${whois}/bin/whois",' \
      --replace-fail '"default": "/usr/lib/nagios/plugins",' '"default": "${monitoring-plugins}/bin",' \
      --replace-fail '"default": "/usr/sbin/sendmail",' '"default": "${system-sendmail}/bin/sendmail",'

    substituteInPlace $out/LibreNMS/wrapper.py --replace-fail '/usr/bin/env php' '${phpPackage}/bin/php'
    substituteInPlace $out/LibreNMS/__init__.py --replace-fail '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'
    substituteInPlace $out/snmp-scan.py --replace-fail '"/usr/bin/env", "php"' '"${phpPackage}/bin/php"'

    substituteInPlace $out/lnms --replace-fail '\App\Checks::runningUser();' '//\App\Checks::runningUser(); //removed as nix forces ownership to root'

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
