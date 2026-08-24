{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  cpio,
  gzip,
  glibc,
  pkgsi686Linux,
  pax-utils,
  makeWrapper,
  python3,
  aflplusplus,
  qemu-nyx,
}:

# this derivation assumes x86_64-linux
assert stdenv.targetPlatform.system == "x86_64-linux";

let
  python3WithPkgs = python3.withPackages (ps: [
    ps.msgpack
    ps.jinja2
  ]);
in
stdenv.mkDerivation {
  version = builtins.readFile (aflplusplus.src + "/nyx_mode/PACKER_VERSION");
  pname = "nyx-packer";

  src = aflplusplus.src;
  postUnpack = ''
    sourceRoot="$sourceRoot/nyx_mode/packer"
  '';

  patches = [
    # this patch does following things:
    #   * write default config to ~/.nyx/nyx.ini because nix store is read-only
    #   * fix https://github.com/nyx-fuzz/packer/issues/35
    #   * apply Matt Morehouse's patch (https://github.com/nyx-fuzz/packer/pull/34)
    ./packer.patch
  ];

  strictDeps = true;

  # compile_64.sh / compile_loader use -O0; _FORTIFY_SOURCE needs optimization
  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [
    cpio
    gzip
    makeWrapper
  ];

  buildInputs = [
    glibc
    glibc.static
    pkgsi686Linux.glibc
  ];

  dontConfigure = true;

  postPatch = ''
    substituteInPlace packer/common/config.py \
      --replace-fail \
        '"QEMU-PT_PATH": "../../QEMU-Nyx/x86_64-softmmu/qemu-system-x86_64"' \
        '"QEMU-PT_PATH": "${qemu-nyx}/bin/qemu-system-x86_64"'

    # fix paths to shared libraries that assume debian FHS
    substituteInPlace linux_initramfs/pack.sh \
      --replace-fail \
        'cp -L /lib/ld-linux.so.2' \
        'cp -L ${pkgsi686Linux.glibc}/lib/ld-linux.so.2' \
      --replace-fail \
        'cp -L /lib/x86_64-linux-gnu/libdl.so.2' \
        'cp -L ${glibc}/lib/libdl.so.2' \
      --replace-fail \
        'cp -L /lib/x86_64-linux-gnu/libc.so.6' \
        'cp -L ${glibc}/lib/libc.so.6' \
      --replace-fail \
        'cp -L /lib64/ld-linux-x86-64.so.2' \
        'cp -L ${glibc}/lib/ld-linux-x86-64.so.2' \
      --replace-fail \
        'cp -L /lib64/libdl.so.2' \
        'cp -L ${glibc}/lib/libdl.so.2' \
      --replace-fail \
        'cp -L /lib64/libc.so.6' \
        'cp -L ${glibc}/lib/libc.so.6' \
      --replace-fail \
        'cp -L /lib32/libc.so.6' \
        'cp -L ${pkgsi686Linux.glibc}/lib/libc.so.6' \
      --replace-fail \
        'cp -L /lib32/libdl.so.2' \
        'cp -L ${pkgsi686Linux.glibc}/lib/libdl.so.2' \
      --replace-fail \
        'cp /lib/x86_64-linux-gnu/libnss_compat.so.2' \
        'cp -L ${glibc}/lib/libnss_compat.so.2' \
      --replace-fail \
        'cp /lib64/libnss_compat.so.2' \
        'cp ${glibc}/lib/libnss_compat.so.2'
  '';

  buildPhase = ''
    runHook preBuild

    pushd packer/linux_x86_64-userspace
    echo "+ bash -e compile_64.sh"
    bash -e compile_64.sh
    popd

    pushd linux_initramfs
    echo "+ bash -e pack.sh"
    bash -e pack.sh
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # copy build tree so python scripts can assume regular relative paths
    cp -r . "$out" && chmod -R u+w "$out"

    PATH="${python3WithPkgs}/bin:$PATH" patchShebangs --build $out/packer
    wrapProgram $out/packer/nyx_packer.py \
      --suffix PATH : ${
        lib.makeBinPath [
          pax-utils
          qemu-nyx
        ]
      }
    wrapProgram $out/packer/nyx_config_gen.py \
      --suffix PATH : ${
        lib.makeBinPath [
          pax-utils
          qemu-nyx
        ]
      }

    runHook postInstall
  '';

  postFixup = ''
    # packer binaries are meant to run inside the vm
    find "$out/packer/linux_x86_64-userspace/bin64" -type f \
      -exec patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 {} \;
  '';

  meta = {
    homepage = "https://github.com/nyx-fuzz/packer";
    description = "image packer for Nyx VMs";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.x86_64;
    maintainers = with lib.maintainers; [ ekzyis ];
  };
}
