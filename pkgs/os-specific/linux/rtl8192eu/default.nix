{ stdenv, lib, fetchFromGitHub, kernel, bc }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in stdenv.mkDerivation rec {
  pname = "rtl8192eu";
  version = "${kernel.version}-4.4.1.20210403";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
    rev = "ab35c7e9672f37d75b7559758c99f6d027607687";
    sha256 = "sha256-sTIaye4oWNYEnNuXlrTLobaFKXzBLsfJXdJuc10EdJI=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ bc ];

  makeFlags = [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

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
