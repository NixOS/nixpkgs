{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
  linuxConsoleTools,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "hid-fanatecff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    rev = lib.versions.majorMinor version;
    hash = "sha256-1Nm/34Er/qfel9LJp++IWd7cTh2Wi93Kgd28YLMVvWo=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace fanatec.rules \
      --replace-fail "/bin/sh" "${bash}/bin/sh"
    substituteInPlace fanatec.rules \
      --replace-fail "/usr/bin/evdev-joystick" "${linuxConsoleTools}/bin/evdev-joystick"

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/udev/rules.d
    cp ${src}/fanatec.rules $out/etc/udev/rules.d/99-fanatec.rules

    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid
    cp hid-fanatec.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid

    runHook postInstall
  '';

  meta = {
    description = "Driver to support FANATEC input devices, in particular ForceFeedback of various wheel-bases";
    homepage = "https://github.com/gotzl/hid-fanatecff";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ theaninova ];
    platforms = lib.platforms.linux;
    broken = stdenv.isAarch64;
  };
}
