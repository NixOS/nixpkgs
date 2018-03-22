{ stdenv, lib, fetchFromGitHub, kernel }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in stdenv.mkDerivation rec {
  name = "rtl8192eu-${kernel.version}-${version}";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
    rev = "4094004";
    sha256 = "0rgcsp8bd5i5ik9b35qipdhq0xd8pva8kdijixxfaxm4vw6kbrvr";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;
  '';

  meta = {
    description = "Realtek rtl8192eu driver";
    homepage = https://github.com/Mange/rtl8192eu-linux-driver;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ troydm ];
  };
}
