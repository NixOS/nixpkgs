{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2017-07-05";

  # This repo is built by merging the latest versions of
  # http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/
  # and
  # http://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/
  # for any given date. This gives us up to date iwlwifi firmware as well as
  # the usual set of firmware. firmware/linux-firmware usually lags kernel releases
  # so iwlwifi cards will fail to load on newly released kernels.
  src = fetchFromGitHub {
    owner = "fpletz";
    repo = "linux-firmware";
    rev = version;
    sha256 = "0vlk043y7c32g4d9hz93j64x372qqrwsq65mh8s5s5xrvamja2if";
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
    maintainers = with maintainers; [ wkennington fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
