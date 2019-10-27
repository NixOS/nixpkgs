{ stdenv, lib, fetchFromGitHub, kernel }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtlwifi";

in stdenv.mkDerivation rec {
  pname = "rtlwifi_new";
  version = "2019-08-21";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtlwifi_new";
    rev = "a108e3de87c2ed30b71c3c4595b79ab7a2f9e348";
    sha256 = "15kjs9i9vvmn1cdzccd5cljf3m45r4ssm65klkj2fdkf3kljj38k";
  };

  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

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
