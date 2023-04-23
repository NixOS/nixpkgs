{ lib, buildGraalvmNativeImage, fetchurl }:

buildGraalvmNativeImage rec {
  pname = "jet";
  version = "0.4.24";

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-8UIPDq+POe5Ss4H8ecHkheYKul4FpGzQgWGQ0N7h41M=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "-H:Log=registerResource:"
    "--no-fallback"
    "--no-server"
  ];

  meta = with lib; {
    description = "CLI to transform between JSON, EDN, YAML and Transit, powered with a minimal query language";
    homepage = "https://github.com/borkdude/jet";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    maintainers = with maintainers; [ ericdallo ];
  };
}
