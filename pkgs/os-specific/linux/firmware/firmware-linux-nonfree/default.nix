{ stdenvNoCC, fetchgit, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2021-02-08";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = lib.replaceStrings ["-"] [""] version;
    sha256 = "0c85cd659312isfz1r87qswsgfhy0rljagcwspnvjljqrh9bsgzq";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0l4xsgxdvjffad7a98n42nyqy3ihs6m6hy3qsfkqin9z10413x5n";

  meta = with lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
