{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "vendor-reset";
  version = "unstable-2021-02-16-${kernel.version}";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "vendor-reset";
    rev = "225a49a40941e350899e456366265cf82b87ad25";
    sha256 = "sha256-xa7P7+mRk4FVgi+YYCcsFLfyNqPmXvy3xhGoTDVqPxw=";
  };

  patches = [
    # Fix build with Linux 5.18.
    # https://github.com/gnif/vendor-reset/pull/58
    (fetchpatch {
      url = "https://github.com/gnif/vendor-reset/commit/5bbffcd6fee5348e8808bdbfcb5b21d455b02f55.patch";
      sha256 = "sha256-L1QxVpcZAVYiaMFCBfL2EJgeMyOR8sDa1UqF1QB3bns=";
    })
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
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "4.19";
  };
}
