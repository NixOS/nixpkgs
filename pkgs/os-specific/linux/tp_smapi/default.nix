{ stdenv, fetchurl, kernel, writeScript, coreutils, gnugrep, jq, curl
}:

let
  data = stdenv.lib.importJSON ./update.json;
in stdenv.mkDerivation rec {
  name = "tp_smapi-${data.version}-${kernel.version}";

  src = fetchurl  { inherit (data) url sha256; };

  hardeningDisable = [ "pic" ];

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

  passthru.updateScript = import ./update.nix {
    inherit writeScript coreutils gnugrep jq curl;
  };

  meta = {
    description = "IBM ThinkPad hardware functions driver";
    homepage = "https://github.com/evgeni/tp_smapi/tree/tp-smapi/0.41";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    # driver is only ment for linux thinkpads i think  bellow platforms should cover it.
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

