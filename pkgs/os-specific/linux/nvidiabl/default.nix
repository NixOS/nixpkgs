{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "nvidiabl-${version}-${kernel.version}";
  version = "2020-10-01";

  # We use a fork which adds support for newer kernels -- upstream has been abandoned.
  src = fetchFromGitHub {
    owner = "yorickvP";
    repo = "nvidiabl";
    rev = "9e21bdcb7efedf29450373a2e9ff2913d1b5e3ab";
    sha256 = "1z57gbnayjid2jv782rpfpp13qdchmbr1vr35g995jfnj624nlgy";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i 's|/sbin/depmod|#/sbin/depmod|' Makefile
  '';

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=$(out)"
    "KVER=${kernel.modDirVersion}"
  ];

  meta = with lib; {
    description = "Linux driver for setting the backlight brightness on laptops using NVIDIA GPU";
    homepage = "https://github.com/yorickvP/nvidiabl";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ yorickvp ];
    broken = kernel.kernelAtLeast "5.18";
  };
}
