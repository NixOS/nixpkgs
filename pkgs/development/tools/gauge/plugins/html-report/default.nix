{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "html-report";
  data = lib.importJSON ./data.json;

  repo = "getgauge/html-report";
  releasePrefix = "html-report-";

  meta = with lib; {
    description = "HTML report generation plugin for Gauge";
    homepage = "https://github.com/getgauge/html-report/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marie ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
