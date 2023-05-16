{ stdenv, lib, fetchFromGitHub, kernel, bc }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in stdenv.mkDerivation rec {
  pname = "rtl8192eu";
<<<<<<< HEAD
  version = "${kernel.version}-4.4.1.20230613";
=======
  version = "${kernel.version}-4.4.1.20220614";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
<<<<<<< HEAD
    rev = "f2fc8af7ab58d2123eed1aa4428e713cdfc27976";
    sha256 = "sha256-OgsxBcXoIP8h9Z0bLsG91/s/+r89Tdn2dPOt4p3sx8k=";
=======
    rev = "6ba1f320963376f15ea216238c0b62ff3e71fa82";
    sha256 = "sha256-c5swRxSjWT1tCcR7tfFKdAdVVmAEYgMZuOwUxGYYESI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ bc ];

  makeFlags = kernel.makeFlags ++ [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Realtek rtl8192eu driver";
    homepage = "https://github.com/Mange/rtl8192eu-linux-driver";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
<<<<<<< HEAD
    broken = stdenv.hostPlatform.isAarch64;
=======
    broken = stdenv.hostPlatform.isAarch64 || kernel.kernelAtLeast "5.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ troydm ];
  };
}
