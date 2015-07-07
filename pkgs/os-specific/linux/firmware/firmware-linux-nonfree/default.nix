{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2015-06-30";

  src = fetchgit {
    url = "http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git";
    rev = "ea901a57054441907e9b127ad407a8554532f992";
    sha256 = "00899r0gakdy2vpgq5zbhbxrl4kyczg1kybv1h3m2lrk9a0j7v67";
  };

  preInstall = ''
    mkdir -p $out
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = http://packages.debian.org/sid/firmware-linux-nonfree;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru = { inherit version; };
}
