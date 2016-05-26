{stdenv, fetchurl, kernel}:

stdenv.mkDerivation rec {
  version = "0.42";
  name = "tp_smapi-${version}-${kernel.version}";

  src = fetchurl {
    url = "https://github.com/evgeni/tp_smapi/releases/download/tp-smapi%2F0.42/tp_smapi-${version}.tgz";
    sha256 = "09rdg7fm423x6sbbw3lvnvmk4nyc33az8ar93xgq0n9qii49z3bv";
  };

  makeFlags = [
    "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "SHELL=/bin/sh"
  ];

  installPhase = ''
    install -v -D -m 644 thinkpad_ec.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/thinkpad_ec.ko"
    install -v -D -m 644 tp_smapi.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/tp_smapi.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = {
    description = "IBM ThinkPad hardware functions driver";
    homepage = "https://github.com/evgeni/tp_smapi/tree/tp-smapi/0.41";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    # driver is only ment for linux thinkpads i think  bellow platforms should cover it.
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

