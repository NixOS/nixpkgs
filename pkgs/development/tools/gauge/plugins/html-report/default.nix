{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  pname = "html-report";
  data = lib.importJSON ./data.json;

  repo = "getgauge/html-report";
  releasePrefix = "html-report-";

  meta = {
    description = "HTML report generation plugin for Gauge";
    homepage = "https://github.com/getgauge/html-report/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
  };
}
