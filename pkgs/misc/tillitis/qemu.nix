{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qemu
, git
, buildPackages
, writeScript
, tillitis-qemu               # for passthru
, tillitis-firmware-softcpu   # for passthru
}:

(qemu.override { enableDocs = false; })
  .overrideAttrs(previousAttrs: {
  version = "8.0.0";

  # This is just `git rebase` of the tillitis fork forward to
  # upstream v8.0.0, with a few very small and very obvious merge
  # conflicts fixed.
  #
  # An official rebase from tillits has been requested:
  # https://github.com/tillitis/qemu/issues/13
  #
  src = fetchFromGitHub {
    owner = "amjoseph-nixpkgs";
    repo = "qemu";
    rev = "8464ccca2dfcad85b22821a10d4ff8e1740b9e4b";
    hash = "sha256-AyCuszTHwlHlx/gYQzDBy6btWWSK8zCvmNjBgzPbSe4=";
    fetchSubmodules = true;
  };

  naiveBuildInputs = previousAttrs.nativeBuildInputs ++ [
    git
  ];

  configureFlags = previousAttrs.configureFlags ++ [
    "--with-git=${buildPackages.git}/bin/git"

    # https://github.com/tillitis/tillitis-key1-apps#running-device-apps-in-qemu
    "--target-list=riscv32-softmmu"

    # https://github.com/tillitis/qemu/issues/3
    "--disable-werror"
  ];

  NIX_CFLAGS_COMPILE = (previousAttrs.NIX_CFLAGS_COMPILE or "") + "-Wno-error=discarded-qualifiers";

  meta = previousAttrs.meta // {
    description = previousAttrs.meta.description + "(tillitis fork)";
    homepage = "https://github.com/tillitis/qemu/";
  };

  passthru = {
    run = writeScript "tillitis-qemu-run" ''
      exec \
        ${tillitis-qemu}/bin/qemu-system-riscv32 \
        -nographic \
        -M tk1,fifo=chrid \
        -bios ${tillitis-firmware-softcpu}/firmware.elf \
        -chardev pty,id=chrid \
        "$@"
    '';
  };
})
