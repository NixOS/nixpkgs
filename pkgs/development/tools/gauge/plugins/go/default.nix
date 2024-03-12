{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  name = "go";
  data = lib.importJSON ./data.json;

  repo = "getgauge-contrib/gauge-go";
  releasePrefix = "gauge-go-";
  systemMap = {
    "aarch64-darwin" = "darwin.arm64";
    "x86_64-darwin" = "darwin.x86_64";
    "x86_64-linux" = "linux.x86_64";
    "i686-linux" = "linux.x86";
    "x86_64-windows" = "windows.x86_64";
    "i386-windows" = "windows.x86";
  };

  meta = {
    description = "Gauge plugin that lets you write tests in Go";
    homepage = "https://github.com/getgauge-contrib/gauge-go";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
