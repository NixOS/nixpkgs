{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel, bc }:

stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2021-05-04";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8188eus";
    rev = "0958f294f90b49d6bad4972b14f90676e5d858d3";
    hash = "sha256-dkCcwvOLxqU1IZ/OXTp67akjWgsaH1Cq4N8d9slMRI8=";
  };

  patches = [
    # Support for kernel version 5.17+
    (fetchpatch {
      url = "https://github.com/aircrack-ng/rtl8188eus/commit/a56696c733b134f21cf81084e55b88f46acc1ec2.patch";
      hash = "sha256-Nky358ymOpYDRDXaemFpSHSQFY1hQBX+BdDIBoGoOck=";
    })

    # Removed 'extern' from inline function declarations
    (fetchpatch {
      url = "https://github.com/aircrack-ng/rtl8188eus/commit/0f1905259ec9b85fd1453be3abd322ff543e12bc.patch";
      hash = "sha256-cQQmytNth2QY577P7kxqpaw4Id+RfZIgWVgvCN0fQxI=";
    })
  ];

  nativeBuildInputs = [ bc ];
  buildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "RealTek RTL8188eus WiFi driver with monitor mode & frame injection support";
    homepage = "https://github.com/aircrack-ng/rtl8188eus";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fortuneteller2k ];
    broken = kernel.isHardened;
  };
}
