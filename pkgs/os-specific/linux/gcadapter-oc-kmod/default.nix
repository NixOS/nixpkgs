{ lib
, fetchFromGitHub
, kernel
, kmod
, buildModule
}:

let
  kerneldir = "lib/modules/${kernel.modDirVersion}";
in buildModule rec {
  pname = "gcadapter-oc-kmod";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "HannesMann";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nqhj3vqq9rnj37cnm2c4867mnxkr8di3i036shcz44h9qmy9d40";
  };

  makeFlags = [
    "KERNEL_SOURCE_DIR=${kernel.dev}/${kerneldir}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  installPhase = ''
    install -D {,$out/${kerneldir}/extra/}gcadapter_oc.ko
  '';

  meta = with lib; {
    description = "Kernel module for overclocking the Nintendo Wii U/Mayflash GameCube adapter";
    homepage = "https://github.com/HannesMann/gcadapter-oc-kmod";
    license = licenses.gpl2;
    maintainers = with maintainers; [ r-burns ];
  };
}
