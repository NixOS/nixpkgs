{ stdenv, lib, fetchFromGitHub, kernel }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtlwifi";

in stdenv.mkDerivation rec {
  name = "rtlwifi_new-${version}";
  version = "2016-09-12";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtlwifi_new";
    rev = "7a1b37d2121e8ab1457f002b2729fc23e6ff3e10";
    sha256 = "0z8grf0fak2ryxwzapp9di77c4bghzkv8lffv76idkcnxgq6sclv";
  };

  hardeningDisable = [ "pic" "format" ];

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
