{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "ruby";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge-ruby";
  releasePrefix = "gauge-ruby-";

  meta = with lib; {
    description = "Gauge plugin that lets you write tests in Ruby";
    homepage = "https://github.com/getgauge/gauge-ruby/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marie ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
