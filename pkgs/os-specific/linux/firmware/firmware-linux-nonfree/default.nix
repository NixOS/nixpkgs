{ stdenv, fetchgit, lib }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2020-11-18";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = lib.replaceStrings ["-"] [""] version;
    sha256 = "107p7h13gncsxqhixqq9zmmswvs910sck54ab10s4m5cafvnaf94";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1319qr3mhbbvbnl8q151pgfpahwzfv9zg0fvpj34z5h0wnvmlr2v";

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
