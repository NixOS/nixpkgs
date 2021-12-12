{ lib
, fetchurl
}:

let
  pname = "netboot.xyz-efi";
  version = "2.0.53";
in fetchurl {
  name = "${pname}-${version}";

  url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz.efi";
  sha256 = "sha256-v7XqrhG94BLTpDHDazTiowQUXu/ITEcgVMmhlqgmSQE=";

  meta = with lib; {
    homepage = "https://netboot.xyz/";
    description = "A tool to boot OS installers and utilities over the network, to be run from a bootloader";
    license = licenses.asl20;
    maintainers = with maintainers; [ Enzime ];
    platforms = platforms.linux;
  };
}
