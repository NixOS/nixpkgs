{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  pname = "rtl8814au";
  version = "${kernel.version}-unstable-2022-05-23";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8814au";
    rev = "687f05c73e22dc14d5f24f2bb92f2ecac3cc71d5";
    sha256 = "08znnihk9rdrwgyzazxqcrzwdjnm5q8ah92bfb552wjv11r87zv1";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE="-Wno-error=incompatible-pointer-types";

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
    description = "Realtek 8814AU USB WiFi driver";
    homepage = "https://github.com/morrownr/8814au";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.lassulus ];
  };
}
