{ stdenv, fetchurl, cabextract, bt-fw-converter }:

# Kernels between 4.2 and 4.7 will not work with
# this packages as they expect the firmware to be named "BCM.hcd"
# see: https://github.com/NixOS/nixpkgs/pull/25478#issuecomment-299034865
stdenv.mkDerivation rec {
  name = "broadcom-bt-firmware-${version}";
  version = "12.0.1.1012";

  src = fetchurl {
    url = "http://download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/04/852bb503-de7b-4810-a7dd-cbab62742f09_7cf83a4c194116648d17707ae37d564f9c70bec2.cab";
    sha256 = "1b1qjwxjk4y91l3iz157kms8601n0mmiik32cs6w9b1q4sl4pxx9";
  };

  nativeBuildInputs = [ cabextract bt-fw-converter ];

  unpackCmd = ''
    mkdir -p ${name}
    cabextract $src --directory ${name}
  '';

  installPhase = ''
    mkdir -p $out/lib/firmware/brcm
    bt-fw-converter -f bcbtums.inf -o $out/lib/firmware/brcm
    for filename in $out/lib/firmware/brcm/*.hcd
    do
      linkname=$(basename $filename | awk 'match($0,/^(BCM)[0-9A-Z]+(-[0-9a-z]{4}-[0-9a-z]{4}\.hcd)$/,c) { print c[1]c[2] }')
      if ! [ -z $linkname ]
      then
        ln -s --relative -T $filename $out/lib/firmware/brcm/$linkname
      fi
    done
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "042frb2dmrqfj8q83h5p769q6hg2b3i8fgnyvs9r9a71z7pbsagq";

  meta = with stdenv.lib; {
    description = "Firmware for Broadcom WIDCOMM® Bluetooth devices";
    homepage = http://www.catalog.update.microsoft.com/Search.aspx?q=Broadcom+bluetooth;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
