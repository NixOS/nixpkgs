{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "rt5677-firmware";

  src = fetchgit {
    url = "https://github.com/raphael/linux-samus";
    rev = "995de6c2093797905fbcd79f1a3625dd3f50be37";
    sha256 = "6e59f7ce24122eb9474e7863e63729de632e4c7afcb8f08534cb2102007f8381";
  };


  installPhase = ''
    mkdir -p $out/lib/firmware
    cp ./firmware/rt5677_elf_vad $out/lib/firmware
  '';

  meta = with stdenv.lib; {
    description = "Firmware for Realtek rt5677 device";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = [ maintainers.zohl ];
  };
}
