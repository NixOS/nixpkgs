{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "vendor-reset";
  version = "unstable-2024-04-16-${kernel.version}";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "vendor-reset";
    rev = "084881c6e9e11bdadaf05798e669568848e698a3";
    hash = "sha256-Klu2uysbF5tH7SqVl815DwR7W+Vx6PyVDDLwoMZiqBI=";
  };

  patches = [
    # This is a temporary, vendored version of this upstream PR:
    # https://github.com/gnif/vendor-reset/pull/86
    # As soon as it is merged, we should be able to update this
    # module and remove the patch.
    ./fix-linux-6.12-build.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D vendor-reset.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux kernel vendor specific hardware reset module";
    homepage = "https://github.com/gnif/vendor-reset";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "4.19";
  };
}
