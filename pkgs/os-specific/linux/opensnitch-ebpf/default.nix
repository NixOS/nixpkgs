{
  lib,
  kernel,
  stdenv,
  clang-tools,
  llvmPackages,
  elfutils,
  flex,
  bison,
  bc,
  opensnitch,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "opensnitch_ebpf";
  version = "${opensnitch.version}-${kernel.version}";

  inherit (opensnitch) src;

  sourceRoot = "${src.name}/ebpf_prog";

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

  env.KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/source";
  env.KERNEL_HEADERS = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  extraConfig = ''
    CONFIG_UPROBE_EVENTS=y
  '';

  installPhase = ''
    runHook preInstall

    for file in opensnitch*.o; do
      install -Dm644 "$file" "$out/etc/opensnitchd/$file"
    done

    runHook postInstall
  '';

  postFixup = ''
    # reduces closure size significantly (fixes https://github.com/NixOS/nixpkgs/issues/391351)
    for file in $out/etc/opensnitchd/*.o; do
      llvm-strip --strip-debug $file
    done
  '';

  passthru.tests = {
    inherit (nixosTests) opensnitch;
  };

  meta = with lib; {
    description = "eBPF process monitor module for OpenSnitch";
    homepage = "https://github.com/evilsocket/opensnitch";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      onny
      grimmauld
    ];
    platforms = platforms.linux;
  };
}
