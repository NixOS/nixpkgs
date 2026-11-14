{
  lib,
  stdenvNoCC,
  kernel,
  ebpf-headers,
  libbpf,
  llvmPackages,
  nixosTests,
  # Program header type that carries a relocatable "$ORIGIN/..." loader
  # path next to an absolute PT_INTERP. It is not standardised, so it is
  # chosen from the OS-specific range PT_LOOS..PT_HIOS. Defaults to ASCII
  # "orig".
  ptInterpOriginType ? lib.fromHexString "6f726967",
}:

let
  ptLoos = lib.fromHexString "60000000";
  ptHios = lib.fromHexString "6fffffff";

  # e_machine values (from include/uapi/linux/elf-em.h) of the 64-bit
  # architectures whose kernels have a BPF JIT.
  elfMachines = {
    x86_64 = 62;
    aarch64 = 183;
    powerpc64le = 21;
    riscv64 = 243;
    loongarch64 = 258;
  };
  elfMachine =
    elfMachines.${stdenvNoCC.hostPlatform.parsed.cpu.name}
      or (throw "binfmt-origin: unsupported architecture ${stdenvNoCC.hostPlatform.parsed.cpu.name}");
in

assert lib.assertMsg (
  ptInterpOriginType >= ptLoos && ptInterpOriginType <= ptHios
) "binfmt-origin: ptInterpOriginType must lie in PT_LOOS..PT_HIOS (0x60000000-0x6fffffff)";

stdenvNoCC.mkDerivation {
  pname = "binfmt-origin";
  version = kernel.version;

  src = ./src;

  nativeBuildInputs = [ llvmPackages.clang-unwrapped ];

  # The objects are compiled against this kernel's BTF so the struct_ops
  # type, the kfuncs and enum bpf_binprm_flags are the ones it will see.
  buildPhase = ''
    runHook preBuild

    for prog in elf_origin script_origin; do
      clang -g -O2 -target bpf -mcpu=v3 \
        -DBPF_NO_KFUNC_PROTOTYPES \
        -DPT_INTERP_ORIGIN=${toString ptInterpOriginType} \
        -DELF_MACHINE=${toString elfMachine} \
        -I${ebpf-headers} -I${lib.getDev libbpf}/include \
        -c "$prog.bpf.c" -o "$prog.bpf.o"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/lib/bpf elf_origin.bpf.o script_origin.bpf.o

    runHook postInstall
  '';

  # BTF in the objects is required by the loader, keep the debug info.
  dontStrip = true;

  passthru = {
    inherit ptInterpOriginType;
    tests = {
      inherit (nixosTests) binfmt-relocatable;
    };
  };

  meta = {
    description = "binfmt_misc BPF handlers resolving $ORIGIN-relative ELF loaders and #! interpreters";
    longDescription = ''
      BPF struct_ops programs for Linux 7.3+ binfmt_misc 'B' entries.
      elf_origin runs ELF binaries whose loader is named relative to the
      binary, through either a PT_INTERP starting with "$ORIGIN/" or a
      PT_INTERP_ORIGIN program header. script_origin does the same for
      "#!" interpreters, on line 1 or as a backwards compatible line 2.
    '';
    license = lib.licenses.gpl2Only;
    platforms = lib.intersectLists lib.platforms.linux (
      lib.concatMap (cpu: lib.platforms.${cpu} or [ ]) (lib.attrNames elfMachines)
    );
    maintainers = with lib.maintainers; [ fzakaria ];
  };
}
