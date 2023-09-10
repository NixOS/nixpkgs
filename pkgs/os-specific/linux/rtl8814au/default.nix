{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  pname = "rtl8814au";
  version = "${kernel.version}-unstable-2023-03-21";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8814au";
    rev = "6f80699e68fd2a9f2bba3f1a56ca06d1b7992bd8";
    hash = "sha256-7dv+8vNI1OLLA4SdZQPL87pTS9HR6mGijzWo9WL7vc0=";
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
