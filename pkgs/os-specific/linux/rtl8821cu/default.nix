{
  lib,
  buildKernelModule,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
  nix-update-script,
}:

buildKernelModule {
  pname = "rtl8821cu";
  version = "0-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210916";
    rev = "07fa9cf0fa8b0c08920c359c725dfc250e91422b";
    hash = "sha256-JAkh0Vnt+Hg16F2xCsFPs5SAmaS2oqdIf45L0hXN0iY=";
  };

  nativeBuildInputs = [ bc ];
  makeFlags = kernelModuleMakeFlags;

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Realtek rtl8821cu driver";
    homepage = "https://github.com/morrownr/8821cu-20210916";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.contrun ];
  };
}
