{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl8852cu";
  version = "${kernel.version}-unstable-20240510";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852cu-20240510";
    rev = "15788c86a7ae14dd74cac7e475b6f4a9953a2c8c";
    hash = "sha256-nd6SoIG28Y29OXlwofrIqH8UNBVq9/TVsapX+ADuw10=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ]
  ++ kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/" \
      --replace-fail 'cp -f $(MODULE_NAME).conf /etc/modprobe.d' "" \
      --replace-fail "sh edit-options.sh" ""
    substituteInPlace ./platform/i386_pc.mk \
      --replace-fail /lib/modules "${kernel.dev}/lib/modules"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    mkdir -p "$out/usr/lib/systemd/system-sleep"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-designated-init"; # Similar to 79c1cf6

  enableParallelBuilding = true;

  meta = {
    description = "Driver for Realtek rtl8852cu and rtl8832cu chipsets";
    homepage = "https://github.com/morrownr/rtl8852cu-20240510";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "6" && kernel.isHardened; # Similar to 79c1cf6
    maintainers = with lib.maintainers; [ u2x1 ];
  };
})
