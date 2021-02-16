{ lib, stdenv, fetchgit, kernel }:

stdenv.mkDerivation rec {
  pname = "hid-playstation-${kernel.version}";
  version = "unstable-2021-02-25";

  src = fetchgit {
    url = "https://aur.archlinux.org/hid-playstation-dkms.git";
    rev = "91d7194235d5d1116c038edf40fc2720f14353ec";
    sha256 = "sha256-Uv1Wd8Fkho2EYSkwFhqQ0c6zE6W/sjHqOHnS2caOc4A=";
  };

  patches = [ "${src}/disable-ff-enabled-check.patch" ];

  makeFlags = [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=\${out}/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid"
  '';

  meta = with lib; {
    description = "Sony's official HID driver for the PS5 DualSense controller";
    homepage = "https://patchwork.kernel.org/project/linux-input/list/?series=429573";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
