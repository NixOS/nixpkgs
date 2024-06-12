let
  source = import ./source.nix;
in {
  stdenvNoCC,
  fetchzip,
  lib,
  rdfind,
  which,
}:

stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = source.version;

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${source.revision}.tar.gz";
    hash = source.sourceHash;
  };

  nativeBuildInputs = [
    rdfind
    which
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = source.outputHash;

  meta = with lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru.updateScript = ./update.sh;
}
