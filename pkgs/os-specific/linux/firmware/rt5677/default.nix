{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "rt5677-firmware";

  src = fetchgit {
    url = "https://github.com/raphael/linux-samus";
    rev = "995de6c2093797905fbcd79f1a3625dd3f50be37";
    sha256 = "0a6lz9wadm47cmva136q6wd0lw03bmymf9ispnzb091a7skwacry";
  };


  installPhase = ''
    mkdir -p $out/lib/firmware
    cp ./firmware/rt5677_elf_vad $out/lib/firmware
  '';

  meta = with stdenv.lib; {
    description = "Firmware for Realtek rt5677 device";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = [ maintainers.zohl ];
    platforms = platforms.linux;
  };
}
