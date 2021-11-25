{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2021-05-04";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8188eus";
    rev = "6146193406b62e942d13d4d43580ed94ac70c218";
    sha256 = "sha256-85STELbFB7QmTaM8GvJNlWvAg6KPAXeYRiMb4cGA6RY=";
  };

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
    broken = kernel.kernelAtLeast "5.15" || kernel.isHardened;
  };
}
