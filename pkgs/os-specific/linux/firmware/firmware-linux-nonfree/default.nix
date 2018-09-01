{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2018-08-25";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "fea76a04f25fd0a217c0d566ff5ff8f23ad3e648";
    sha256 = "1xy1s9vd7jny4hf4f1hzhlbnm0l4pnw7xycky0v6kfwlg5nnjii5";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1p1dkzclj718w7di81s6486dn5zw77c4i2qn63bvp9q4vid452hn";

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
