{ stdenvNoCC, fetchgit, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2021-07-16";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "refs/tags/" + lib.replaceStrings ["-"] [""] version;
    sha256 = "185pnaqf2qmhbcdvvldmbar09zgaxhh3h8x9bxn6079bcdpaskn6";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0g470hj2ylpviijfpjqzsndn2k8kkscj27wqwk51xlk8cr3mrahb";

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
