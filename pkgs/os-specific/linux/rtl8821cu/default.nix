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
  version = "unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210916";
    rev = "d74134a1c68f59f2b80cdd6c6afb8c1a8a687cbf";
    hash = "sha256-ExT7ONQeejFoMwUUXKua7wMnRi+3IYayLmlWIEWteK4=";
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
