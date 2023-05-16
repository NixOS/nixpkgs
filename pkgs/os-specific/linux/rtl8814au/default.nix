{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  pname = "rtl8814au";
<<<<<<< HEAD
  version = "${kernel.version}-unstable-2023-03-21";
=======
  version = "${kernel.version}-unstable-2022-11-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8814au";
<<<<<<< HEAD
    rev = "6f80699e68fd2a9f2bba3f1a56ca06d1b7992bd8";
    hash = "sha256-7dv+8vNI1OLLA4SdZQPL87pTS9HR6mGijzWo9WL7vc0=";
=======
    rev = "932df6f7da6c3a384cf91f33eb195097eb0cb6c5";
    hash = "sha256-nMQiT59IIhzpePWWDiyCQFmYLWM42L/mG0BKsbEwreo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  hardeningDisable = [ "pic" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Realtek 8814AU USB WiFi driver";
    homepage = "https://github.com/morrownr/8814au";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.lassulus ];
  };
}
