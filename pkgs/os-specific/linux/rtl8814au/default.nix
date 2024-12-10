{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation {
  pname = "rtl8814au";
  version = "${kernel.version}-unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8814au";
    rev = "d7945c1e0244c83cbbad4da331648246f12eaee9";
    hash = "sha256-idjHlvyFpQgLGfNAPpZKRnLdXnAogUW3qGHC1WzGVmA=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  hardeningDisable = [ "pic" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
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
