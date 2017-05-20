{ stdenv, fetchurl, cabextract, bt-fw-converter }:

# Kernels between 4.2 and 4.7 will not work with
# this packages as they expect the firmware to be named "BCM.hcd"
# see: https://github.com/NixOS/nixpkgs/pull/25478#issuecomment-299034865
stdenv.mkDerivation rec {
  name = "broadcom-bt-firmware-${version}";
  version = "12.0.1.1011";

  src = fetchurl {
    url = "http://download.windowsupdate.com/d/msdownload/update/driver/drvs/2016/11/200033618_94cfea9130b30c04bc602cd3dcc1f9a793fc75bb.cab";
    sha256 = "6091e49c9d9c71cbe3aed2db3c0d60994ff562804c3b40e1e8bcbb818180987b";
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
        ln -s -T $filename $out/lib/firmware/brcm/$linkname
      fi
    done
  '';

  meta = with stdenv.lib; {
    description = "Firmware for Broadcom WIDCOMM® Bluetooth devices";
    homepage = http://www.catalog.update.microsoft.com/Search.aspx?q=Broadcom+bluetooth;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
