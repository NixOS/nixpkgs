{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2015-03-20";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "f404336ba808cbd57547196e13367079a23b822c";
    sha256 = "0avz5vxax2b3s4gafib47vih1lbq78agdmpjcjnnnykw2kschkwa";
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
