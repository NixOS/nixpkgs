{
  lib,
  stdenv,
  kernel,
  bpftools,
}:

stdenv.mkDerivation {
  pname = "btf";
  inherit (kernel) version;

  nativeBuildInputs = [ bpftools ];

  dontUnpack = true;

  buildPhase = ''
    objcopy --dump-section .BTF=btf ${lib.getDev kernel}/vmlinux /dev/null
    mkdir -p $out/include
    bpftool btf dump file btf format c > $out/include/vmlinux.h
  '';

  meta = {
    description = "Kernel headers generated from embedded BTF";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ artemist ];
    platforms = lib.platforms.linux;
  };
}
