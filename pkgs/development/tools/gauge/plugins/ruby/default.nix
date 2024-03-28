{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  name = "ruby";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge-ruby";
  releasePrefix = "gauge-ruby-";
  systemMap = {
    "aarch64-darwin" = "darwin.arm64";
    "x86_64-darwin" = "darwin.x86_64";
    "aarch64-linux" = "linux.arm64";
    "x86_64-linux" = "linux.x86_64";
    "x86_64-windows" = "windows.x86_64";
    "aarch64-windows" = "windows.arm64";
  };

  meta = {
    description = "Gauge plugin that lets you write tests in Ruby";
    homepage = "https://github.com/getgauge/gauge-ruby/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
