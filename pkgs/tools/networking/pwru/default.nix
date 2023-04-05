{ lib
, buildGoModule
, fetchFromGitHub
, llvmPackages_12
}:

buildGoModule rec {
  pname = "pwru";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "pwru";
    rev = "v${version}";
    hash = "sha256-muBt4sJ77rM3ydan6T7qlnbBW+B5NGIzyIElPDRo40s=";
  };

  # needed to build bpf libs
  hardeningDisable = [ "stackprotector" ];

  nativeBuildInputs = [
    llvmPackages_12.clang
    llvmPackages_12.libllvm
  ];

  preBuild = ''
    echo "0-3" > system-cpu-possible
    sed -i.bak vendor/github.com/cilium/ebpf/internal/cpu.go -e "s|/sys/devices/system/cpu/possible|$(realpath system-cpu-possible)|"

    go generate

    mv vendor/github.com/cilium/ebpf/internal/cpu.go{.bak,}
  '';

  vendorHash = null;

  ldflags = [ "-s" "-w" "-X github.com/cilium/pwru/internal/pwru.Version=${version}" ];

  meta = with lib; {
    description = "Packet, where are you? -- eBPF-based Linux kernel networking debugger";
    homepage = "https://github.com/cilium/pwru";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
