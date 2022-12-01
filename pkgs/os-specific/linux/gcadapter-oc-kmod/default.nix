{ lib, stdenv
, fetchFromGitHub
, kernel
, kmod
}:

let
  kerneldir = "lib/modules/${kernel.modDirVersion}";
in stdenv.mkDerivation rec {
  pname = "gcadapter-oc-kmod";
  version = "unstable-2021-12-11";

  src = fetchFromGitHub {
    owner = "HannesMann";
    repo = pname;
    rev = "d4ddf15deb74c51dbdfc814d481ef127c371f444";
    sha256 = "sha256-bHA1611rcO8/d48b1CHsiurEt3/n+5WErtHXAU7Eh1o=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
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
    platforms = platforms.linux;
  };
}
