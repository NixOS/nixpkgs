{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  name = "screenshot";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge_screenshot";
  releasePrefix = "screenshot-";
  systemMap = {
    "i386-darwin" = "darwin.x86";
    "x86_64-darwin" = "darwin.x86_64";
    "aarch64-linux" = "linux.arm64";
    "x86_64-linux" = "linux.x86_64";
    "i386-linux" = "linux.x86";
    "x86_64-windows" = "windows.x86_64";
    "i386-windows" = "windows.x86";
  };

  meta = {
    description = "Gauge plugin to take screenshots";
    homepage = "https://github.com/getgauge/gauge_screenshot/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
