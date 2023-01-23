{ lib, stdenvNoCC, fetchurl, cpio, xz, pkgs }:

let

  version = "1.43_5";


  # Updated according to https://github.com/patjak/bcwc_pcie/pull/81/files
  # and https://github.com/patjak/bcwc_pcie/blob/5a7083bd98b38ef3bd223f7ee531d58f4fb0fe7c/firmware/Makefile#L3-L9
  # and https://github.com/patjak/bcwc_pcie/blob/5a7083bd98b38ef3bd223f7ee531d58f4fb0fe7c/firmware/extract-firmware.sh

  # From the Makefile:
  dmgUrl = "https://updates.cdn-apple.com/2019/cert/041-88431-20191011-e7ee7d98-2878-4cd9-bc0a-d98b3a1e24b1/OSXUpd10.11.5.dmg";
  dmgRange = "204909802-207733123"; # the whole download is 1.3GB, this cuts it down to 2MB
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

stdenvNoCC.mkDerivation {

  pname = "facetimehd-firmware";
  inherit version;
  src = fetchurl {
    url = dmgUrl;
    sha256 = "0s8crlh8rvpanzk1w4z3hich0a3mw0m5xhpcg07bxy02calhpdk1";
    curlOpts = "-r ${dmgRange}";
  };

  dontUnpack = true;
  dontInstall = true;

  buildInputs = [ cpio xz ];

  buildPhase = ''
    ${unpack}/bin/unpack
    dd bs=1 skip=${firmwareOffset} count=${firmwareSize} if=${firmwareIn} of=${firmwareOut}.gz &> /dev/null
    mkdir -p $out/lib/firmware/facetimehd
    gunzip -c ${firmwareOut}.gz > $out/lib/firmware/facetimehd/${firmwareOut}
  '';

  meta = with lib; {
    description = "facetimehd firmware";
    homepage = "https://support.apple.com/kb/DL1877";
    license = licenses.unfree;
    maintainers = with maintainers; [ womfoo grahamc ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
