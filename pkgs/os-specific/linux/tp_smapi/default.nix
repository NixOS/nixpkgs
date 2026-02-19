{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "tp_smapi-${finalAttrs.version}-${kernel.version}";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "linux-thinkpad";
    repo = "tp_smapi";
    tag = "tp-smapi/${finalAttrs.version}";
    hash = "sha256-rB+DNgWUXd1oQBbDgVEAJVJ16nKCaKDtWGAmpcFsx+A=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "SHELL=${stdenv.shell}"
    "HDAPS=1"
  ];

  installPhase = ''
    runHook preInstall

    install -v -D -m 644 thinkpad_ec.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/thinkpad_ec.ko"
    install -v -D -m 644 tp_smapi.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/tp_smapi.ko"
    install -v -D -m 644 hdaps.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/hdapsd.ko"

    runHook postInstall
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = {
    description = "IBM ThinkPad hardware functions driver";
    homepage = "https://github.com/linux-thinkpad/tp_smapi";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    # driver is only meant for linux thinkpads, bellow platforms should cover it.
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
