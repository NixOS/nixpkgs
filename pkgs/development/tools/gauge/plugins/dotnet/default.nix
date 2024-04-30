{ lib
, makeGaugePlugin
, gauge-unwrapped
}:

makeGaugePlugin {
  pname = "dotnet";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge-dotnet";
  releasePrefix = "gauge-dotnet-";
  isCrossArch = true;

  meta = {
    description = "Gauge plugin that lets you write tests in C#";
    homepage = "https://github.com/getgauge/gauge-dotnet/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    inherit (gauge-unwrapped.meta) platforms;
  };
}
