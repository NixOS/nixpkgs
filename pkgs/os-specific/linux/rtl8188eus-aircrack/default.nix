{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2026-10-23";

  src = fetchFromGitHub {
    owner = "gglluukk";
    repo = "rtl8188eus";
    rev = "2d93b74367ce42a96b8f75df303513d89dd0594b";
    hash = "sha256-rG+mZZnfGcl9/3t5GgVzowvGgCoPR/moinJGFYAAqwY=";
  };

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail 'install -p -m 644 $(MODULE_NAME).ko  $(MODDESTDIR)' \
        '$(MAKE) -C $(KSRC) M=$(shell pwd) modules_install'
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=$(out)"
    "INSTALL_MOD_DIR=kernel/net/wireless"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
  ];

  hardeningDisable = [ "pic" ];
  enableParallelBuilding = true;

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "RealTek RTL8188eus WiFi driver with monitor mode & frame injection support";
    homepage = "https://github.com/gglluukk/rtl8188eus";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      moni
      nix-julia
    ];
  };
}
