{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "go";
  data = lib.importJSON ./data.json;

  repo = "getgauge-contrib/gauge-go";
  releasePrefix = "gauge-go-";

  meta = {
    description = "Gauge plugin that lets you write tests in Go";
    homepage = "https://github.com/getgauge-contrib/gauge-go";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
