{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "java";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge-java";
  releasePrefix = "gauge-java-";

  meta = {
    description = "Gauge plugin that lets you write tests in Java";
    homepage = "https://github.com/getgauge/gauge-java/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = with lib.sourceTypes; [
      # Native binary written in go
      binaryNativeCode
      # Jar files
      binaryBytecode
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
