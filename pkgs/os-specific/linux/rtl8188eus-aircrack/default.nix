{ lib, stdenv, fetchFromGitHub, kernel, bc, fetchpatch }:

stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2022-03-19";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8188eus";
    rev = "0958f294f90b49d6bad4972b14f90676e5d858d3";
    sha256 = "sha256-dkCcwvOLxqU1IZ/OXTp67akjWgsaH1Cq4N8d9slMRI8=";
  };

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  patches = [
    (fetchpatch {
      url = "https://github.com/aircrack-ng/rtl8188eus/commit/daa3a2e12290050be3af956915939a55aed50d5f.patch";
      hash = "sha256-VsvaAhO74LzqUxbmdDT9qwVl6Y9lXfGfrHHK3SbnOVA=";
    })
  ];

  hardeningDisable = [ "pic" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ bc ];

  buildInputs = kernel.moduleBuildDependencies;

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = with lib; {
    description = "RealTek RTL8188eus WiFi driver with monitor mode & frame injection support";
    homepage = "https://github.com/aircrack-ng/rtl8188eus";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fortuneteller2k ];
    broken = (lib.versionAtLeast kernel.version "5.17");
  };
}
