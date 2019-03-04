{ stdenv, fetchurl, makeWrapper, pkgconfig, kronosnet, nss, nspr, libqb
, dbus, rdma-core, libstatgrab, net_snmp
, enableDbus ? false
, enableInfiniBandRdma ? false
, enableMonitoring ? false
, enableSnmp ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "corosync";
  version = "3.0.1";

  src = fetchurl {
    url = "http://build.clusterlabs.org/corosync/releases/${pname}-${version}.tar.gz";
    sha256 = "0zk75yknvhc691y0j4lkh1bx55mryzdgw60mrcr5j6fid1xbfnqy";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  buildInputs = [
    kronosnet nss nspr libqb
  ] ++ optional enableDbus dbus
    ++ optional enableInfiniBandRdma rdma-core
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

  preConfigure = optionalString enableInfiniBandRdma ''
    # configure looks for the pkg-config files
    # of librdmacm and libibverbs
    # Howver, rmda-core does not provide a pkg-config file
    # We give the flags manually here:
    export rdmacm_LIBS=-lrdmacm
    export rdmacm_CFLAGS=" "
    export ibverbs_LIBS=-libverbs
    export ibverbs_CFLAGS=" "
  '';

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
    maintainers = with maintainers; [ montag451 ];
  };
}
