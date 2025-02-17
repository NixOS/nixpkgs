{
  lib,
  stdenvNoCC,
  intel-npu-driver,
  ...
}:

stdenvNoCC.mkDerivation {
  inherit (intel-npu-driver) version src;
  pname = "intel-npu-firmware";

  installPhase = ''
    mkdir -p $out/lib/firmware/intel/vpu
    cp -P firmware/bin/*.bin $out/lib/firmware/intel/vpu
  '';

  meta = {
    homepage = "https://github.com/intel/linux-npu-driver";
    description = "Intel NPU (Neural Processing Unit) firmware";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pseudocc ];
  };
}
