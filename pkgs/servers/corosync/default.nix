{ stdenv, fetchurl, makeWrapper, pkgconfig, nss, nspr, libqb
, dbus ? null
, librdmacm ? null, libibverbs ? null
, libstatgrab ? null
, net_snmp ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "corosync-2.3.4";

  src = fetchurl {
    url = "http://build.clusterlabs.org/corosync/releases/${name}.tar.gz";
    sha256 = "1m276b060fjghr93hdzfag81whi5ph65dc2ka8ln1igm3kxr7bix";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
