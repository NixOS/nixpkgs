{ lib
, stdenv
, linuxPackages
, kernel
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "framework-laptop-kmod";
  version = "0-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "DHowett";
    repo = "framework-laptop-kmod";
    rev = "cfff3d242c11dc3ebfa70e7771ee1c094bf2f368";
    hash = "sha256-B9KUiGrizl8+1lZctUSmvw9VXL5wDuuWgzVffbG1Rbk=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D framework_laptop.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
    runHook postInstall
  '';

  meta = with lib; {
    description = "Kernel module that exposes the Framework Laptop (13, 16)'s battery charge limit and LEDs to userspace";
    homepage = "https://github.com/DHowett/framework-laptop-kmod";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ gaykitty ];
    platforms = platforms.linux;
  };
}
