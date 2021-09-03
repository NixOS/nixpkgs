{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtl8821au";
  version = "${kernel.version}-unstable-2021-05-18";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821au";
    rev = "6f6a9d5772bb2b75f18374c01c82c6b3e8e3244d";
    sha256 = "sha256-RqtLR3sNcLXhUrNloSTRKubL1SVwzbVe73AsBYYSXNE=";
  };

  nativeBuildInputs = [ bc nukeReferences ];
  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" "format" ];

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

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "rtl8821AU and rtl8812AU chipset driver with firmware";
    homepage = "https://github.com/morrownr/8821au";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ plchldr ];
  };
}
