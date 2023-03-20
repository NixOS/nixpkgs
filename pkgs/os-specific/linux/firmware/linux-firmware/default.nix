{
  stdenvNoCC,
  fetchzip,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = "20230515";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${version}.tar.gz";
    hash = "sha256-VcA873r9jVYqDqEcvz/PVGfCAhLXr0sMXQincWNLEIs=";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  meta = with lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };
}
