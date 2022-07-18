{ lib, buildPythonPackage, fetchFromGitHub, python3Packages }:

buildPythonPackage rec {
  pname = "persistent-evdev";
  version = "unstable-2022-05-07";

  src = fetchFromGitHub {
    owner = "aiberia";
    repo = pname;
    rev = "52bf246464e09ef4e6f2e1877feccc7b9feba164";
    sha256 = "d0i6DL/qgDELet4ew2lyVqzd9TApivRxL3zA3dcsQXY=";
  };

  propagatedBuildInputs = with python3Packages; [
    evdev pyudev
  ];

  postPatch = ''
    patchShebangs bin/persistent-evdev.py
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp bin/persistent-evdev.py $out/bin

    mkdir -p $out/etc/udev/rules.d
    cp udev/60-persistent-input-uinput.rules $out/etc/udev/rules.d
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/aiberia/persistent-evdev";
    description = "Persistent virtual input devices for qemu/libvirt/evdev hotplug support";
    license = licenses.mit;
    maintainers = [ maintainers.lodi ];
    platforms = platforms.linux;
  };
}
