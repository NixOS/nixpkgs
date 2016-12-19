{ stdenv, fetchurl, cpio, xz, pkgs }:

let

  version = "1.43_4";


  # Updated according to https://github.com/patjak/bcwc_pcie/pull/81/files
  # and https://github.com/patjak/bcwc_pcie/blob/5a7083bd98b38ef3bd223f7ee531d58f4fb0fe7c/firmware/Makefile#L3-L9
  # and https://github.com/patjak/bcwc_pcie/blob/5a7083bd98b38ef3bd223f7ee531d58f4fb0fe7c/firmware/extract-firmware.sh

  # From the Makefile:
  dmgUrl = "https://support.apple.com/downloads/DL1877/en_US/osxupd10.11.5.dmg";
  dmgRange = "205261917-208085450"; # the whole download is 1.3GB, this cuts it down to 2MB
  # Notes:
  # 1. Be sure to update the sha256 below in the fetch_url
  # 2. Be sure to update the homepage in the meta

  # Also from the Makefile (OS_DRV, OS_DRV_DIR), but seems to not change:
  firmwareIn = "./System/Library/Extensions/AppleCameraInterface.kext/Contents/MacOS/AppleCameraInterface";
  firmwareOut = "firmware.bin";

  # The following are from the extract-firmware.sh
  firmwareOffset = "81920"; # Variable: firmw_offsets
  firmwareSize = "603715"; # Variable: firmw_sizes


  # separated this here as the script will fail without the 'exit 0'
  unpack = pkgs.writeScriptBin "unpack" ''
    xzcat -Q $src | cpio --format odc -i -d ${firmwareIn}
    exit 0
  '';

in

stdenv.mkDerivation {

  name = "facetimehd-firmware-${version}";
  src = fetchurl {
    url = dmgUrl;
    sha256 = "0xqkl4yds0n9fdjvnk0v5mj382q02crry6wm2q7j3ncdqwsv02sv";
    curlOpts = "-r ${dmgRange}";
  };

  phases = [ "buildPhase" ];

  buildInputs = [ cpio xz ];

  buildPhase = ''
    ${unpack}/bin/unpack
    dd bs=1 skip=${firmwareOffset} count=${firmwareSize} if=${firmwareIn} of=${firmwareOut}.gz &> /dev/null
    mkdir -p $out/lib/firmware/facetimehd
    gunzip -c ${firmwareOut}.gz > $out/lib/firmware/facetimehd/${firmwareOut}
  '';

  meta = with stdenv.lib; {
    description = "facetimehd firmware";
    homepage = https://support.apple.com/downloads/DL1877;
    license = licenses.unfree;
    maintainers = with maintainers; [ womfoo grahamc ];
    platforms = platforms.linux;
  };

}
