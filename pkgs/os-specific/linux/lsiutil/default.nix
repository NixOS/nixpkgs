{ stdenv, fetchurl, unzip }:

let

  version = "1.60";

  src = fetchurl {
    name = "lsiutil-${version}.zip";
    url = "http://www.lsi.com/DistributionSystem/AssetDocument/support/downloads/hbas/fibre_channel/hardware_drivers/LSIUtil%20Kit_${version}.zip";
    sha256 = "1d4337faa56e24f7d98db87b9de94d6e2c17ab671f4e301b93833eea08b9e426";
  };  

in

stdenv.mkDerivation rec {
  name = "lsiutils-${version}";
  
  srcs = [ src "Source/lsiutil.tar.gz" ];

  buildInputs = [ unzip ];

  sourceRoot = "lsiutil";

  preBuild =
    ''
      mkdir -p $out/bin
      substituteInPlace Makefile --replace /usr/bin $out/bin
      substituteInPlace lsiutil.c \
        --replace /sbin/modprobe modprobe \
        --replace /bin/mknod $(type -P mknod)
    '';

  installPhase = "true";
  
  meta = {
    homepage = http://www.lsi.com/;
    description = "LSI Logic Fusion MPT command line management tool";
    license = stdenv.lib.licenses.unfree;
  };
}
