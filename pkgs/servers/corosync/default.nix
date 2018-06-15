{ stdenv, fetchurl, makeWrapper, pkgconfig, nss, nspr, libqb
, dbus, librdmacm, libibverbs, libstatgrab, net_snmp
, enableDbus ? false
, enableInfiniBandRdma ? false
, enableMonitoring ? false
, enableSnmp ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "corosync-2.4.3";

  src = fetchurl {
    url = "http://build.clusterlabs.org/corosync/releases/${name}.tar.gz";
    sha256 = "15y5la04qn2lh1gabyifygzpa4dx3ndk5yhmaf7azxyjx0if9rxi";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  buildInputs = [
    nss nspr libqb
  ] ++ optional enableDbus dbus
    ++ optional enableInfiniBandRdma [ librdmacm libibverbs ]
    ++ optional enableMonitoring libstatgrab
    ++ optional enableSnmp net_snmp;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-logdir=/var/log/corosync"
    "--enable-watchdog"
    "--enable-qdevices"
  ] ++ optional enableDbus "--enable-dbus"
    ++ optional enableInfiniBandRdma "--enable-rdma"
    ++ optional enableMonitoring "--enable-monitoring"
    ++ optional enableSnmp "--enable-snmp";

  installFlags = [
    "sysconfdir=$(out)/etc"
    "localstatedir=$(out)/var"
    "COROSYSCONFDIR=$(out)/etc/corosync"
    "INITDDIR=$(out)/etc/init.d"
    "LOGROTATEDIR=$(out)/etc/logrotate.d"
  ];

  postInstall = ''
    wrapProgram $out/bin/corosync-blackbox \
      --prefix PATH ":" "$out/sbin:${libqb}/sbin"
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://corosync.org/;
    description = "A Group Communication System with features for implementing high availability within applications";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington montag451 ];
  };
}
