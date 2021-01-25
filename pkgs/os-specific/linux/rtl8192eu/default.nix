{ stdenv, lib, fetchFromGitHub, kernel, bc }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in stdenv.mkDerivation rec {
  name = "rtl8192eu-${kernel.version}-${version}";
  version = "unstable-2021-01-11";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
    rev = "faf68bbf82623335e7997a473f9222751e275927";
    sha256 = "1rz1j1yy66nwbxqsd7v9albhfjal210g8xis4vqmjk96zk0fz86r";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ bc ];

  makeFlags = [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;
  '';

  meta = {
    description = "Realtek rtl8192eu driver";
    homepage = "https://github.com/Mange/rtl8192eu-linux-driver";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ troydm ];
  };
}
