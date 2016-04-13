{ stdenv, fetchurl, cpio, xz, pkgs }:

let

  version = "1.43";

  dmgRange = "420107885-421933300"; # the whole download is 1.3GB, this cuts it down to 2MB

  firmwareIn = "./System/Library/Extensions/AppleCameraInterface.kext/Contents/MacOS/AppleCameraInterface";
  firmwareOut = "firmware.bin";
  firmwareOffset = "81920";
  firmwareSize = "603715";

  # separated this here as the script will fail without the 'exit 0'
  unpack = pkgs.writeScriptBin "unpack" ''
    xzcat -Q $src | cpio --format odc -i -d ${firmwareIn}
    exit 0
  '';

in

stdenv.mkDerivation {

  name = "facetimehd-firmware-${version}";

  src = fetchurl {
    url = "https://support.apple.com/downloads/DL1849/en_US/osxupd10.11.2.dmg";
    sha256 = "1jw6sy9vj27amfak83cs2c7q856y4mk1wix3rl4q10yvd9bl4k9x";
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
    homepage = https://support.apple.com/downloads/DL1849;
    license = licenses.unfree;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
