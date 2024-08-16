{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  pname = "ruby";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge-ruby";
  releasePrefix = "gauge-ruby-";

  meta = {
    description = "Gauge plugin that lets you write tests in Ruby";
    homepage = "https://github.com/getgauge/gauge-ruby/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
  };
}
