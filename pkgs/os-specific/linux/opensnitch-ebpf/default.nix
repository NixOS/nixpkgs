{ lib
, kernel
, stdenv
, clang-tools
, llvmPackages
, elfutils
, flex
, bison
, bc
, opensnitch
}:

stdenv.mkDerivation rec {
  pname = "opensnitch_ebpf";
  version = "${opensnitch.version}-${kernel.version}";

  inherit (opensnitch) src;

  sourceRoot = "source/ebpf_prog";

  nativeBuildInputs = with llvmPackages; [
    bc
    bison
    clang
    clang-tools
    elfutils
    flex
    libllvm
  ];

  # We set -fno-stack-protector here to work around a clang regression.
  # This is fine - bpf programs do not use stack protectors
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=opensnitch-ebpf-module&id=984b952a784eb701f691dd9f2d45dfeb8d15053b
  env.NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  env.KERNEL_DIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/source";
  env.KERNEL_HEADERS="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  extraConfig =''
    CONFIG_UPROBE_EVENTS=y
  '';

  installPhase = ''
    runHook preInstall
    for file in opensnitch*.o; do
      install -Dm644 "$file" "$out/etc/opensnitchd/$file"
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "eBPF process monitor module for OpenSnitch";
    homepage = "https://github.com/evilsocket/opensnitch";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
