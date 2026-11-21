{
  version,
  src,
  isModular,
  kernelPackage,

  lib,
  stdenv,
  liburing,
  libnl,
  bpftrace,
  libcap,
  numactl,
  libcap_ng,
  fuse,
  alsa-lib,
  python3,
  libmnl,
  libbpf,
  popt,
  pkg-config,
  mbedtls,
  llvmPackages,
  coreutils,
  elfutils,
  zlib,
  openssl,
  rsync,
  buildPackages,
  hid-tools,
  bash,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  name = "linux-${version}-kselftests";

  inherit src;

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [
    liburing
    libnl
    bpftrace
    libcap
    numactl
    libcap_ng
    fuse
    alsa-lib
    elfutils
    zlib
    libmnl
    openssl
    libbpf
    popt
    mbedtls
  ]
  # A handful of selftests (e.g. bpf, landlock, exec, x86) link some of
  # their binaries with `-static`, which requires glibc's static
  # archives. `stdenv.cc.libc` (the dynamic glibc) must be listed
  # *before* `stdenv.cc.libc.static` here: buildInputs are added to
  # NIX_LDFLAGS as `-L` flags in order, and since static glibc's output
  # only contains `.a` files (no `.so`), putting it first would make
  # the linker pick the static libc for every binary -- including
  # dynamically-linked host tools like the kernel's own `fixdep` --
  # which breaks at runtime with an IFUNC circular dependency error.
  # Listing the dynamic glibc first ensures `ld` resolves `libc.so`
  # there for ordinary links, while `-static` links (which only look
  # for `.a` files) still fall through to the static archive.
  ++ lib.optionals (stdenv.hostPlatform.libc == "glibc") [
    stdenv.cc.libc
    stdenv.cc.libc.static
  ];

  nativeBuildInputs = [
    pkg-config
    rsync
    llvmPackages.llvm
    (python3.withPackages (ps: [
      ps.pyyaml
      ps.jsonschema
      ps.pytest
      ps.pytest-tap
      hid-tools
    ]))
  ];

  env = {
    # BPF programs used by some selftests (e.g. hid, bpf) are compiled
    # with clang for the `bpf` target. Use the unwrapped compiler, as
    # cc-wrapper injects flags (hardening, --gcc-toolchain) that
    # `clang --target=bpf` rejects under -Werror, but still let it find
    # the libc and Linux uapi headers as it would on a FHS system.
    CLANG = buildPackages.writeShellScript "clang-bpf" ''
      exec ${lib.getExe' buildPackages.llvmPackages.clang-unwrapped "clang"} \
        -idirafter ${lib.getDev stdenv.cc.libc}/include "$@"
    '';
  }
  // lib.optionalAttrs isModular {
    # BPF-based selftests generate vmlinux.h from the BTF of the kernel
    # they are built for.
    VMLINUX_BTF = "${kernelPackage.dev}/vmlinux";
  };

  # Several selftests (and the libbpf they vendor) are built with
  # `-O0 -Werror`, which turns _FORTIFY_SOURCE's "requires compiling
  # with optimization" warning into an error.
  # Some selftests (e.g. size/get_size) are linked `-static
  # -nostartfiles`; the stack protector would pull in
  # `__stack_chk_fail` and with it libc's startup code, which then
  # fails to link.
  hardeningDisable = [
    "fortify"
    "stackprotector"
  ];

  postPatch = ''
    # Several selftest build steps invoke generated/vendored scripts
    # (e.g. scripts/bpf_doc.py) directly, before the standard fixup
    # phase would normally patch their `#!/usr/bin/env ...` shebangs,
    # so do it upfront here.
    patchShebangs scripts tools

    # tools/testing/selftests/ublk/kublk.h includes <linux/io_uring.h>
    # before <liburing.h>. liburing's bundled copy of io_uring.h is
    # guarded by the same macro (LINUX_IO_URING_H) as the kernel's own
    # uapi header, so whichever is included first "wins". Since
    # liburing (2.14) defines newer flags (e.g. IORING_SETUP_SQE_MIXED)
    # that aren't in this kernel's uapi header yet, including the
    # kernel header first causes liburing.h to see those flags as
    # undeclared. Swap the order so liburing's complete definitions
    # take precedence.
    substituteInPlace tools/testing/selftests/ublk/kublk.h \
      --replace-fail $'#include <linux/io_uring.h>\n#include <liburing.h>' \
                     $'#include <liburing.h>\n#include <linux/io_uring.h>'

    # Some stable kernels backported unix_listen.c, which relies on
    # lib.mk adding the selftests dir to the include path, without the
    # lib.mk change that does so.
    if [ -f tools/testing/selftests/net/af_unix/unix_listen.c ]; then
      substituteInPlace tools/testing/selftests/net/af_unix/unix_listen.c \
        --replace-quiet '#include "kselftest_harness.h"' '#include "../../kselftest_harness.h"'
    fi

    substituteInPlace tools/testing/selftests/cgroup/with_stress.sh \
      --replace-quiet '/usr/bin/true' '${lib.getExe' coreutils "true"}'

    substituteInPlace \
      tools/testing/selftests/net/packetdrill/tcp_sendfile_sendfile-simple.pkt \
      --replace-quiet '/bin/rm' '${lib.getExe' coreutils "rm"}' \
      --replace-quiet '/bin/dd' '${lib.getExe' coreutils "dd"}'

    substituteInPlace \
      tools/testing/selftests/net/packetdrill/set_sysctls.py \
      --replace-quiet '/bin/bash' '${lib.getExe' bash "bash"}'
  '';

  buildPhase = ''
    runHook preBuild

    make headers
    make -C tools/testing/selftests FORCE_TARGETS=1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make -C tools/testing/selftests install INSTALL_PATH=$out

    patchShebangs $out

    runHook postInstall
  '';
})
