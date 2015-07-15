{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2015-07-12";

  src = fetchgit {
    url = "http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git";
    rev = "5e6d7a9d70b562c60471e234f78137020d65ccbf";
    sha256 = "06gvjdqpbayfv696hxn9xjkbzddj1hy6z9aahi156lvj96qb9z49";
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
