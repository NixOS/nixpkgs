{ stdenv, fetchgit }:

let
  version = "17657c35869baa999b454e868cd3d5a7e1656425";
  shortVersion = stdenv.lib.substring 0 7 version;
in
stdenv.mkDerivation {
  name = "firmware-linux-nonfree-${shortVersion}";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = version;
    sha256 = "15lv58wf3vjs4dpxvx3a7wn0pj83952wa2ab6ajfl3pbdhcvkzjb";
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
