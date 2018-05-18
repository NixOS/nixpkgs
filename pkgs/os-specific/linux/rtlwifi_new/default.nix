{ stdenv, lib, fetchFromGitHub, kernel }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtlwifi";

in stdenv.mkDerivation rec {
  name = "rtlwifi_new-${version}";
  version = "2018-02-17";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtlwifi_new";
    rev = "0588ac0cc5f530e7764705416370b70d3c2afedc";
    sha256 = "1vs8rfw19lcs04bapa97zlnl5x0kf02sdw5ik0hdm27wgk0z969m";
  };

  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;
  '';

  meta = {
    description = "The newest Realtek rtlwifi codes";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ tvorog ];
    priority = -1;
  };
}
