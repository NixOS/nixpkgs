{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

let
  kerneldir = "lib/modules/${kernel.modDirVersion}";
in stdenv.mkDerivation rec {
  pname = "gvusb2";
  version = "2020-07-27-unstable";

  src = fetchFromGitHub {
    owner = "Isaac-Lozano";
    repo = pname;
    rev = "811fb0f6ee4ef62e0e346a293bb5e3b61ad10b7d";
    sha256 = "0sxspwizcpd6a63awnd6czxylp48rw3h22mf8hf0gh514gklyy5a";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SOURCE_DIR=${kernel.dev}/${kerneldir}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  patches = with lib; [
    ./Makefile.patch
  ] ++ (optional (versionOlder kernel.version "5.7") ./vfl_type_grabber.patch);

  installPhase = ''
    install -D {,$out/${kerneldir}/extra/}gvusb2-sound.ko
    install -D {,$out/${kerneldir}/extra/}gvusb2-video.ko
  '';

  meta = with lib; {
    description = "A linux driver for the IO-DATA GV-USB2 SD capture device";
    homepage = "https://github.com/Isaac-Lozano/GV-USB2-Driver";
    license = with licenses [ bsd3 gpl2Only ];
    maintainers = with maintainers; [ djanatyn ];
    platforms = platforms.linux;
  };
}
