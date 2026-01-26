{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  evdev,
  pyudev,
  udevCheckHook,
}:

buildPythonPackage rec {
  pname = "persistent-evdev";
  version = "unstable-2022-05-07";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "aiberia";
    repo = pname;
    rev = "52bf246464e09ef4e6f2e1877feccc7b9feba164";
    sha256 = "d0i6DL/qgDELet4ew2lyVqzd9TApivRxL3zA3dcsQXY=";
  };

  propagatedBuildInputs = [
    evdev
    pyudev
  ];

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  postPatch = ''
    patchShebangs bin/persistent-evdev.py
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/persistent-evdev.py $out/bin

    mkdir -p $out/etc/udev/rules.d
    cp udev/60-persistent-input-uinput.rules $out/etc/udev/rules.d

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/aiberia/persistent-evdev";
    description = "Persistent virtual input devices for qemu/libvirt/evdev hotplug support";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lodi ];
    platforms = lib.platforms.linux;
    mainProgram = "persistent-evdev.py";
  };
}
