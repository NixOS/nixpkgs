{ stdenv, fetchgit, lib }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2020-01-22";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = lib.replaceStrings ["-"] [""] version;
    sha256 = "0256p99bqwf1d1s6gqnzpjcdmg6skcp1jzz64sd1p29xxrf0pzfa";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1d2jvy395jpfq0gli7q5p571lcb9p5y0y8qr8p8rlcmczh4gry64";

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = http://packages.debian.org/sid/firmware-linux-nonfree;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
