{ stdenv, lib, fetchFromGitHub, kernel, bc }:

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in stdenv.mkDerivation rec {
  pname = "rtl8192eu";
  version = "${kernel.version}-4.4.1.20220614";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
    rev = "6ba1f320963376f15ea216238c0b62ff3e71fa82";
    sha256 = "sha256-c5swRxSjWT1tCcR7tfFKdAdVVmAEYgMZuOwUxGYYESI=";
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
    broken = stdenv.hostPlatform.isAarch64 || kernel.kernelAtLeast "5.18";
    maintainers = with maintainers; [ troydm ];
  };
}
