{
  lib,
  bpftools,
  kernel,
  runCommand,
}:

# BTF is architecture-independent, so the extraction can run on the build
# machine even when the kernel targets another architecture.
runCommand "linux-${kernel.version}-ebpf-headers"
  {
    nativeBuildInputs = [ bpftools ];

    passthru = {
      inherit kernel;
    };

    meta = {
      description = "vmlinux.h (kernel BTF) for BPF programs, from Linux ${kernel.version}";
      homepage = "https://docs.kernel.org/bpf/btf.html";
      license = lib.licenses.gpl2Only;
      platforms = lib.platforms.linux;
    };
  }
  ''
    mkdir -p $out
    bpftool btf dump file ${kernel.dev}/vmlinux format c > $out/vmlinux.h
  ''
