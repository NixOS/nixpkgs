{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "go";
  data = lib.importJSON ./data.json;

  repo = "getgauge-contrib/gauge-go";
  releasePrefix = "gauge-go-";

  meta = with lib; {
    description = "Gauge plugin that lets you write tests in Go";
    homepage = "https://github.com/getgauge-contrib/gauge-go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marie ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
