{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "screenshot";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge_screenshot";
  releasePrefix = "screenshot-";

  meta = with lib; {
    description = "Gauge plugin to take screenshots";
    homepage = "https://github.com/getgauge/gauge_screenshot/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marie ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
