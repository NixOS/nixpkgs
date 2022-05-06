{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  pname = "rtl8814au";
  version = "${kernel.version}-unstable-2022-02-21";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8814au";
    rev = "a538e3878c4b7b0b012f2d2fe7804390caaebd90";
    sha256 = "sha256-xBGbcy/WonFrNflMlFCD/JQOFKhPrv0J3j2XcXWc6hk=";
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
