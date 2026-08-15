{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "tsme-test";
  version = "${kernel.version}-unstable-2026-02-09";

  src = fetchFromGitHub {
    owner = "AMDESE";
    repo = "mem-encryption-tests";
    rev = "361bf41092aec06d7f6e7be239a62bc5a5ff2c66";
    hash = "sha256-aDv4gXcAXOBnJ256Ph06q0qBa9bSXvTbAG+AClFJUTI=";
  };

  patches = [
    # tsme-test.c calls kzalloc()/kzalloc_node()/kfree() without including
    # <linux/slab.h>. It only compiled on newer kernels because slab.h is
    # reachable transitively via <linux/mm.h> (mm.h -> huge_mm.h -> fs.h ->
    # slab.h); the fs.h -> slab.h link was added in v5.18 and is absent from
    # v5.17 and earlier, so the module fails to build on 5.10/5.15. Add the
    # include explicitly.
    # https://github.com/torvalds/linux/commit/8b9f3ac5b01db85c6cf74c2c3a71280cc3045c9c
    ./include-slab.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/lib/modules/${kernel.modDirVersion}/extra tsme-test.ko
    runHook postInstall
  '';

  meta = {
    description = "Kernel driver to test the status of AMD TSME (Transparent Secure Memory Encryption)";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lyn ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/AMDESE/mem-encryption-tests";
  };
}
