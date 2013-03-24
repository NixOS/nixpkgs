{stdenv, fetchurl, kernelDev}:

stdenv.mkDerivation {
  name = "tp_smapi-0.41-${kernelDev.version}";

  src = fetchurl {
    url = "https://github.com/downloads/evgeni/tp_smapi/tp_smapi-0.41.tar.gz";
    sha256 = "6aef02b92d10360ac9be0db29ae390636be55017990063a092a285c70b54e666";
  };

  buildInputs = [ kernelDev ];

  makeFlags = [
    "KBASE=${kernelDev}/lib/modules/${kernelDev.modDirVersion}"
    "SHELL=/bin/sh"
  ];

  installPhase = ''
    install -v -D -m 644 thinkpad_ec.ko "$out/lib/modules/${kernelDev.modDirVersion}/kernel/drivers/firmware/thinkpad_ec.ko"
    install -v -D -m 644 tp_smapi.ko "$out/lib/modules/${kernelDev.modDirVersion}/kernel/drivers/firmware/tp_smapi.ko"
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

