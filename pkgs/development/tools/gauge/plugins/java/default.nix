{ lib
, makeGaugePlugin
}:
makeGaugePlugin {
  name = "java";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge-java";
  releasePrefix = "gauge-java-";
  systemMap = {
    "aarch64-darwin" = "darwin.arm64";
    "x86_64-darwin" = "darwin.x86_64";
    "aarch64-linux" = "linux.arm64";
    "x86_64-linux" = "linux.x86_64";
    "i686-linux" = "linux.386";
    "x86_64-windows" = "windows.x86_64";
    "i386-windows" = "windows.386";
  };

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
  };
}
