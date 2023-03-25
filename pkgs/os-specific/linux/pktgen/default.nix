{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, dpdk
, libbsd
, libpcap
, lua5_3
, numactl
, util-linux
, gtk2
, which
, withGtk ? false
}:

stdenv.mkDerivation rec {
  pname = "pktgen";
  version = "22.07.1";

  src = fetchFromGitHub {
    owner = "pktgen";
    repo = "Pktgen-DPDK";
    rev = "pktgen-${version}";
    sha256 = "sha256-wBLGwVdn3ymUTVv7J/kbQYz4WNIgV246PHg51+FStUo=";
  };

  patches = [
    (fetchpatch {
      # Ealier DPDK deprecated some macros, which were finally removed in >= 22.11
      url = "https://github.com/pktgen/Pktgen-DPDK/commit/089ef94ac04629f7380f5e618443bcacb2cef5ab.patch";
      sha256 = "sha256-ITU/dIfu7QPpdIVYuCuDhDG9rVF+n8i1YYn9bFmQUME=";
    })
  ];

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [
    dpdk libbsd libpcap lua5_3 numactl which
  ] ++ lib.optionals withGtk [
    gtk2
  ];

  RTE_SDK = dpdk;
  GUI = lib.optionalString withGtk "true";

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=address"
    "-Wno-error=use-after-free"
  ];

  # requires symbols from this file
  NIX_LDFLAGS = "-lrte_net_bond";

  postPatch = ''
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${util-linux}/bin/lscpu
  '';

  postInstall = ''
    # meson installs unneeded files with conflicting generic names, such as
    # include/cli.h and lib/liblua.so.
    rm -rf $out/include $out/lib
  '';

  meta = with lib; {
    description = "Traffic generator powered by DPDK";
    homepage = "http://dpdk.org/";
    license = licenses.bsdOriginal;
    platforms =  platforms.linux;
    maintainers = [ maintainers.abuibrahim ];
  };
}
