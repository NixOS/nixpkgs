{ stdenv, fetchurl }:

let
  packages = [
    # Kernel 2.6.28+
    { name = "4965-ucode-228.61.2.24"; sha256 = "1n5af3cci0v40w4gr0hplqr1lfvhghlbzdbf60d6185vpcny2l5m"; }

    # Kernel 2.6.29+
    { name = "3945-ucode-15.32.2.9"; sha256 = "0baf07lblwsq841zdcj9hicf11jiq06sz041qcybc6l8yyhhcqjk"; }
  ];

  fetchPackage =
    { name, sha256 }: fetchurl {
      name = "iwlwifi-${name}.tgz";
      url = "http://wireless.kernel.org/en/users/Drivers/iwlegacy?action=AttachFile&do=get&target=iwlwifi-${name}.tgz";
      inherit sha256;
    };

  srcs = map fetchPackage packages;

in stdenv.mkDerivation {
  name = "iwlegacy";
  inherit srcs;

  unpackPhase = ''
    mkdir -p ./firmware
  '';

  buildPhase = ''
    for src in $srcs; do
      tar zxf $src
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r iwlwifi-*/*.ucode "$out/lib/firmware/"
  '';

  meta = {
    description = "Binary firmware collection from intel";
    homepage = http://wireless.kernel.org/en/users/Drivers/iwlwifi;
    license = stdenv.lib.licenses.unfreeRedistributableFirmware;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
