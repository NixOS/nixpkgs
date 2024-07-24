{ stdenv, lib, fetchFromGitHub, kernel, bc }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in stdenv.mkDerivation {
  pname = "rtl8192eu";
  version = "${kernel.version}-4.4.1.20240507";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
    rev = "27410641da6926eb1ac565068ff89d35f7496328";
    sha256 = "sha256-/BztTE3yKw35Oo7KkzHMtD+8qpJNXWiSwR3YjrotR0I=";
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
