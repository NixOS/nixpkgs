{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "firmware-linux-nonfree-2015-02-27";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "cef33368c4d3425f11306496f0250f8ef1cf3c1f";
    sha256 = "0az6b7fbhanqdc9v9dl651yqqnfbm1npdibip196vnmd5qlv2iw4";
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
}
