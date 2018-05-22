{ stdenv, lib, fetchurl, pkgconfig
, dpdk, libpcap, numactl, utillinux
, gtk2, withGtk ? false
}:

let

  # pktgen needs a specific version of lua to apply its patch (see lib/lua/Makefile).
  lua = rec {
    name = "lua-5.3.4";
    basename = name + ".tar.gz";
    src = fetchurl {
      url = "https://www.lua.org/ftp/${basename}";
      sha256 = "0320a8dg3aci4hxla380dx1ifkw8gj4gbw5c4dz41g1kh98sm0gn";
    };
  };

in stdenv.mkDerivation rec {
  name = "pktgen-${version}";
  version = "3.5.0";

  src = fetchurl {
    url = "http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-${version}.tar.xz";
    sha256 = "1gy99jr9dbwzi9pd3w5k673h3pfnbkz6rbzmrkwcyis72pnphy5z";
  };

  nativeBuildInputs = stdenv.lib.optionals withGtk [ pkgconfig ];

  buildInputs =
    [ dpdk libpcap numactl ]
    ++ stdenv.lib.optionals withGtk [gtk2];

  RTE_SDK = "${dpdk}/share/dpdk";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";
  GUI = stdenv.lib.optionalString withGtk "true";

  NIX_CFLAGS_COMPILE = [ "-msse3" ];

  postPatch = let dpdkMajor = lib.versions.major dpdk.version; in ''
    substituteInPlace app/Makefile --replace 'yy :=' 'yy := ${dpdkMajor} #'
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${utillinux}/bin/lscpu

    ln -s ${lua.src} lib/lua/${lua.basename}
    make -C lib/lua get_tarball # unpack and patch
    substituteInPlace lib/lua/${lua.name}/src/luaconf.h --replace /usr/local $out
  '';

  installPhase = ''
    install -d $out/bin
    install -m 0755 app/${RTE_TARGET}/pktgen $out/bin
    install -d $out/lib/lua/5.3
    install -m 0644 Pktgen.lua $out/lib/lua/5.3
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Traffic generator powered by DPDK";
    homepage = http://dpdk.org/;
    license = licenses.bsdOriginal;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
