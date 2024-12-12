{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fanout";
  version = "unstable-2022-10-17-${kernel.version}";

  src = fetchFromGitHub {
    owner = "bob-linuxtoys";
    repo = "fanout";
    rev = "69b1cc69bf425d1a5f83b4e84d41272f1caa0144";
    hash = "sha256-Q19c88KDFu0A6MejZgKYei9J2693EjRkKtR9hcRcHa0=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  patches = [
    ./remove_auto_mknod.patch
  ];

  hardeningDisable = [
    "format"
    "pic"
  ];

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  passthru.tests = { inherit (nixosTests) fanout; };

  meta = with lib; {
    description = "Kernel-based publish-subscribe system";
    homepage = "https://github.com/bob-linuxtoys/fanout";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ therishidesai ];
    platforms = platforms.linux;
  };
}
