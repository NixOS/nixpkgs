{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "framework-laptop-kmod";
  version = "0-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "DHowett";
    repo = "framework-laptop-kmod";
    rev = "6164bc3dec24b6bb2806eedd269df6a170bcc930";
    hash = "sha256-OwtXQR0H4GNlYjVZ5UU5MEM6ZOjlV3B0x2auYawbS2U=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D framework_laptop.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Kernel module that exposes the Framework Laptop (13, 16)'s battery charge limit and LEDs to userspace";
    homepage = "https://github.com/DHowett/framework-laptop-kmod";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ gaykitty ];
    platforms = platforms.linux;
    broken = lib.versionOlder kernel.version "6.1";
  };
}
