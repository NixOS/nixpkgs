{ stdenv, lib, fetchFromGitHub, kernel, bc }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in stdenv.mkDerivation rec {
  pname = "rtl8192eu";
  version = "${kernel.version}-4.4.1.20230613";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
    rev = "f2fc8af7ab58d2123eed1aa4428e713cdfc27976";
    sha256 = "sha256-OgsxBcXoIP8h9Z0bLsG91/s/+r89Tdn2dPOt4p3sx8k=";
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
    broken = stdenv.hostPlatform.isAarch64;
    maintainers = with maintainers; [ troydm ];
  };
}
