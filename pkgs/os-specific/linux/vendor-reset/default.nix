{ fetchFromGitHub, kernel, lib, buildModule }:

buildModule rec {
  pname = "vendor-reset";
  version = "unstable-2021-02-16";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "vendor-reset";
    rev = "225a49a40941e350899e456366265cf82b87ad25";
    sha256 = "sha256-xa7P7+mRk4FVgi+YYCcsFLfyNqPmXvy3xhGoTDVqPxw=";
  };

  hardeningDisable = [ "pic" ];

  installPhase = ''
    install -D vendor-reset.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';

  overridePlatforms = [ "x86_64-linux" ];

  meta = with lib; {
    description = "Linux kernel vendor specific hardware reset module";
    homepage = "https://github.com/gnif/vendor-reset";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wedens ];
    broken = kernel.kernelOlder "4.19";
  };
}
