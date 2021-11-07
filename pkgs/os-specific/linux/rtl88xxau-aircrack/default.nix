{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel }:

let
  rev = "3a64331a1c809bbbc21eca63b825970f213ec5ac";
in
stdenv.mkDerivation rec {
  pname = "rtl88xxau-aircrack";
  version = "${kernel.version}-${builtins.substring 0 6 rev}";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8812au";
    inherit rev;
    sha256 = "sha256-goaN80imfCeUwiHokJd10CFKskE3iL5BO/xOQk6PtHE=";
  };

  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE="-Wno-error=incompatible-pointer-types";

  # Fix build for 5.12 kernels
  patches = [
    (fetchpatch {
      url = "https://github.com/aircrack-ng/rtl8812au/commit/9b4c60a89c2a55f36454b950a86246b6b86a9681.patch";
      sha256 = "sha256-HPhTLstqAePF3H6WeM9Fu4/8UjNL+9xl4L8xq3NOWuM=";
    })
  ];

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
    description = "Aircrack-ng kernel module for Realtek 88XXau network cards\n(8811au, 8812au, 8814au and 8821au chipsets) with monitor mode and injection support.";
    homepage = "https://github.com/aircrack-ng/rtl8812au";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.jethro ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    broken = kernel.kernelAtLeast "5.15";
  };
}
