{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2015-05-13";

  src = fetchgit {
    url = "http://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "3161bfa479d5e9ed4f46b57df9bcecbbc4f8eb3c";
    sha256 = "0np6vwcnas3pzp38man3cs8j5ijs0p3skyzla19sfxzpwmjvfpjq";
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
