{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "firmware-linux-nonfree-2015-02-24";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "4517261caab34742afdeaf0c36128b9579675717";
    sha256 = "0w386nfwlqhk1wn7zzhfxkxx06nzqasc4dr0qq61wc29s9qlgi3c";
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
