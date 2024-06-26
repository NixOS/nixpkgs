{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  pname = "screenshot";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge_screenshot";
  releasePrefix = "screenshot-";

  meta = {
    description = "Gauge plugin to take screenshots";
    homepage = "https://github.com/getgauge/gauge_screenshot/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
  };
}
