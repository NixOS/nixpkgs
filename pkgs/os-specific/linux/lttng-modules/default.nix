{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${kernel.version}";
<<<<<<< HEAD
  version = "2.13.10";
=======
  version = "2.13.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lttng";
    repo = "lttng-modules";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-R5qwB1ayw0KueMBSSxm0TwINt78N6w356kY7WGBX0zM=";
=======
    hash = "sha256-6ohWsGUGFz7QlHkKWyW5edpSsBTE9DFS3v6EsH9wNZo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken = (lib.versions.majorMinor kernel.modDirVersion) == "5.10" || (lib.versions.majorMinor kernel.modDirVersion) == "5.4";
  };
}
