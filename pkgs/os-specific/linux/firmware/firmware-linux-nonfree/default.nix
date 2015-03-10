{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "firmware-linux-nonfree-2015-03-09";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "020e534ec90106d42a890cd9d090b24e3d158c53";
    sha256 = "101mpps0jcv2dd4jh1w3j4h78d4iv8n8r1cnf4br2vg66zl3zg9v";
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
