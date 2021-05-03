{ stdenv, fetchFromGitHub, kernel, lib }:

stdenv.mkDerivation rec {
  name = "vendor-reset-${version}-${kernel.version}";
  version = "unstable-2021-02-16";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "vendor-reset";
    rev = "225a49a40941e350899e456366265cf82b87ad25";
    sha256 = "sha256-xa7P7+mRk4FVgi+YYCcsFLfyNqPmXvy3xhGoTDVqPxw=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D vendor-reset.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';

  meta = with lib; {
    description = "Linux kernel vendor specific hardware reset module";
    homepage = "https://github.com/gnif/vendor-reset";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wedens ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "4.19";
  };
}
