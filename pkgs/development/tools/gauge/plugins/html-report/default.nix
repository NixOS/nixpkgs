{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  name = "html-report";
  data = lib.importJSON ./data.json;

  repo = "getgauge/html-report";
  releasePrefix = "html-report-";
  systemMap = {
    "aarch64-darwin" = "darwin.arm64";
    "x86_64-darwin" = "darwin.x86_64";
    "aarch64-linux" = "linux.arm64";
    "x86_64-linux" = "linux.x86_64";
    "i686-linux" = "linux.x86";
    "x86_64-windows" = "windows.x86_64";
    "i386-windows" = "windows.x86";
  };

  meta = {
    description = "HTML report generation plugin for Gauge";
    homepage = "https://github.com/getgauge/html-report/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
