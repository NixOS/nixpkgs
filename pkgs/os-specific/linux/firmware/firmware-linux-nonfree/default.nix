{ stdenv, fetchgit, lib }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2020-10-22";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = lib.replaceStrings ["-"] [""] version;
    sha256 = "15l32993pfm0albx7ky64c5i60vph150hrdkg87md15919a6naia";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0y2dpp3gklzym2gr0w9wddf6cn6p0sv9n2xh401j1299sjsr57m9";

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
