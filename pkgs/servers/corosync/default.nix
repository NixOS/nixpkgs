{ stdenv, fetchurl, makeWrapper, pkgconfig, nss, nspr, libqb
, dbus ? null
, librdmacm ? null, libibverbs ? null
, libstatgrab ? null
, net_snmp ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "corosync-2.4.1";

  src = fetchurl {
    url = "http://build.clusterlabs.org/corosync/releases/${name}.tar.gz";
    sha256 = "0w8m97ih7a2g99pmjsckw4xwbgzv96xdgg62s2a4qbgnw4yl637y";
  };

  buildInputs = [
    makeWrapper pkgconfig nss nspr libqb
    dbus librdmacm libibverbs libstatgrab net_snmp
  ];

  # Remove when rdma libraries gain pkgconfig support
  ibverbs_CFLAGS = optionalString (libibverbs != null)
    "-I${libibverbs}/include/infiniband";
  ibverbs_LIBS = optionalString (libibverbs != null) "-libverbs";
  rdmacm_CFLAGS = optionalString (librdmacm != null)
    "-I${librdmacm}/include/rdma";
  rdmacm_LIBS = optionalString (librdmacm != null) "-lrdmacm";

  configureFlags = [
    "--enable-watchdog"
    "--enable-qdevices"
  ] ++ optional (dbus != null) "--enable-dbus"
    ++ optional (librdmacm != null && libibverbs != null) "--enable-rdma"
    ++ optional (libstatgrab != null) "--enable-monitoring"
    ++ optional (net_snmp != null) "--enable-snmp";

  postInstall = ''
    wrapProgram $out/bin/corosync-blackbox \
      --prefix PATH ":" "$out/sbin:${libqb}/sbin"
  '';

  meta = {
    homepage = http://corosync.org/;
    description = "A Group Communication System with features for implementing high availability within applications";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
