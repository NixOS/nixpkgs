{ stdenvNoCC, fetchgit, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2021-03-15";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "refs/tags/" + lib.replaceStrings ["-"] [""] version;
    sha256 = "sha256-BnYqveVFJk/tVYgYuggXgYGcUCZT9iPkCQIi48FOTWc=";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-TzAMGj7IDhzXcFhHAd15aZvAqyN+OKlJTkIhVGoTkIs=";

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
