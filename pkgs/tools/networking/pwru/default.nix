{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, llvmPackages_13
, flex
, bison
, buildPackages
, testers
, pwru
}:

let
  inherit (stdenv.targetPlatform) system;
  goArchs = {
    "x86_64-linux" = "amd64";
    "aarch64-linux" = "arm64";
  };
  goArch = goArchs.${system} or (throw "Unsupported platform ${system}");

  pname = "pwru";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "cilium";
    repo = "pwru";
    rev = "v${version}";
    hash = "sha256-9UMuHDPDL8nPdL6U+BHHSXvd0iDUigVOa5Tel7n5L4Q=";
  };

  libpcap = stdenv.mkDerivation {
    pname = "${pname}-pcap";
    inherit version src;

    patches = [ ./fix-pcap-cmake.patch ];

    sourceRoot = "source/libpcap";

    nativeBuildInputs = [
      pkg-config
      buildPackages.cmake
      flex
      bison
    ];

    depsBuildBuild = [ buildPackages.stdenv.cc ];

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=OFF"
      "-DDISABLE_LINUX_USBMON=ON"
      "-DDISABLE_BLUETOOTH=ON"
      "-DDISABLE_NETMAP=ON"
      "-DDISABLE_DBUS=ON"
      "-DBUILD_WITH_LIBNL=OFF"
    ];
  };
in buildGoModule {
  inherit pname version src;

  # needed to build bpf libs
  hardeningDisable = [ "stackprotector" ];

  vendorHash = null;

  CGO_ENABLED = 1;
  CGO_LDFLAGS = "-static";

  nativeBuildInputs = [
    # only used for go generate
    llvmPackages_13.clang
    llvmPackages_13.libllvm
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [ stdenv.cc.libc.static libpcap ];

  preBuild = ''
    echo "0-3" > system-cpu-possible
    sed -i.bak vendor/github.com/cilium/ebpf/internal/cpu.go \
      -e "s|/sys/devices/system/cpu/possible|$(realpath system-cpu-possible)|"

    env TARGET_GOARCH=${goArch} \
      go generate

    mv vendor/github.com/cilium/ebpf/internal/cpu.go{.bak,}
  '';

  ldflags = [
    "-w"
    "-s"
    "-linkmode=external"
    "-X github.com/cilium/pwru/internal/pwru.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = pwru;
    command = "pwru --version";
  };

  meta = with lib; {
    description = "eBPF-based Linux kernel networking debugger";
    homepage = "https://github.com/cilium/pwru";
    changelog = "https://github.com/cilium/pwru/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
