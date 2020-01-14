{ stdenv, lib, fetchurl, meson, ninja, pkgconfig
, dpdk, libbsd, libpcap, lua5_3, numactl, utillinux
, gtk2, which, withGtk ? false
}:

stdenv.mkDerivation rec {
  pname = "pktgen";
  version = "19.12.0";

  src = fetchurl {
    url = "http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/${pname}-${version}.tar.xz";
    sha256 = "1clfviz1qa4hysslcg6i29vsxwl9f6j1y7zf9wwx9br3yq08x956";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs =
    [ dpdk libbsd libpcap lua5_3 numactl which ]
    ++ stdenv.lib.optionals withGtk [gtk2];

  RTE_SDK = dpdk;
  GUI = stdenv.lib.optionalString withGtk "true";

  NIX_CFLAGS_COMPILE = "-msse3";

  patches = [ ./configure.patch ];

  postPatch = ''
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${utillinux}/bin/lscpu
  '';

  postInstall = ''
    # meson installs unneeded files with conflicting generic names, such as
    # include/cli.h and lib/liblua.so.
    rm -rf $out/include $out/lib
  '';

  meta = with stdenv.lib; {
    description = "Traffic generator powered by DPDK";
    homepage = http://dpdk.org/;
    license = licenses.bsdOriginal;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
