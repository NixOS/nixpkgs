{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "xml-report";
  data = lib.importJSON ./data.json;

  repo = "getgauge/xml-report";
  releasePrefix = "xml-report-";

  meta = with lib; {
    description = "XML report generation plugin for Gauge";
    homepage = "https://github.com/getgauge/xml-report/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marie ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
