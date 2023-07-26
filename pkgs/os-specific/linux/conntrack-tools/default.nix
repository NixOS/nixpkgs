{ fetchurl, lib, stdenv, flex, bison, pkg-config, libmnl, libnfnetlink
, libnetfilter_conntrack, libnetfilter_queue, libnetfilter_cttimeout
, libnetfilter_cthelper, libtirpc
, systemdSupport ? true, systemd
}:

stdenv.mkDerivation rec {
  pname = "conntrack-tools";
  version = "1.4.7";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/conntrack-tools/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-CZ3rz1foFpDO1X9Ra0k1iKc1GPSMFNZW+COym0/CS10=";
  };

  buildInputs = [
    libmnl libnfnetlink libnetfilter_conntrack libnetfilter_queue
    libnetfilter_cttimeout libnetfilter_cthelper libtirpc
  ] ++ lib.optionals systemdSupport [
    systemd
  ];
  nativeBuildInputs = [ flex bison pkg-config ];

  configureFlags = [
    (lib.enableFeature systemdSupport "systemd")
  ];

  meta = with lib; {
    homepage = "http://conntrack-tools.netfilter.org/";
    description = "Connection tracking userspace tools";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
