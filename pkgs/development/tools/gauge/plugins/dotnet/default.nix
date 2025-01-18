{
  lib,
  makeGaugePlugin,
  gauge-unwrapped,
  stdenv,
}:

makeGaugePlugin {
  pname = "dotnet";
  data = lib.importJSON ./data.json;

  repo = "getgauge/gauge-dotnet";
  releasePrefix = "gauge-dotnet-";
  isCrossArch = true;

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  meta = with lib; {
    description = "Gauge plugin that lets you write tests in C#";
    homepage = "https://github.com/getgauge/gauge-dotnet/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marie ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    inherit (gauge-unwrapped.meta) platforms;
  };
}
