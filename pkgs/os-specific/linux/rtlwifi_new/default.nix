{ stdenv, lib, fetchFromGitHub, kernel }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtlwifi";

in stdenv.mkDerivation rec {
  name = "rtlwifi_new-${version}";
  version = "2017-07-18";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtlwifi_new";
    rev = "a24cb561b4d23187ea103255336daa7ca88791a7";
    sha256 = "1w9rx5wafcp1vc4yh7lj332bv78szl6gmx3ckr8yl6c39alqcv0d";
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
