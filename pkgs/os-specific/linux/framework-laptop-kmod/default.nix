{ lib
, stdenv
, linuxPackages
, kernel
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "framework-laptop-kmod";
  version = "0-unstable-2024-01-02";

  src = fetchFromGitHub {
    owner = "DHowett";
    repo = "framework-laptop-kmod";
    rev = "a9e8db9ba2959b75c1fb820ffac8fa189f0f63c3";
    hash = "sha256-Ai/OxvkaKPltri8R0oyfmxQLUVfaj6Q8vebrhmWYhUU=";
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
    description = "A kernel module that exposes the Framework Laptop (13, 16)'s battery charge limit and LEDs to userspace.";
    homepage = "https://github.com/DHowett/framework-laptop-kmod";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gaykitty ];
    platforms = platforms.linux;
  };
}
