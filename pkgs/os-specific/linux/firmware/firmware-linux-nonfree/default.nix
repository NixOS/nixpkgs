{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2018-12-13";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "813fa1fc6fba6638decd974c4a6a2e485069ea15";
    sha256 = "0zspisbrvplgz1plk4ya22h7ilnsk60srk4q38h6n5d18fpn7rdw";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1yr6wcvc3s97h4w0qapma4l17dqsj175an6kmn5w6dppz19g0r5b";

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
