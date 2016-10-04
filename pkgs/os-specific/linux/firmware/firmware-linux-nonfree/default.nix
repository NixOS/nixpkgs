{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2016-07-12";

  # This repo is built by merging the latest versions of
  # http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/
  # and
  # http://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/
  # for any given date. This gives us up to date iwlwifi firmware as well as
  # the usual set of firmware. firmware/linux-firmware usually lags kernel releases
  # so iwlwifi cards will fail to load on newly released kernels.
  src = fetchFromGitHub {
    owner = "wkennington";
    repo = "linux-firmware";
    rev = "cccb6a0da98372bd66787710249727ad6b0aaf72";
    sha256 = "1c7h8i37nbyy37zqhybxd3y6aqabfv4nrdkjg789w67mdnn6hka0";
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
