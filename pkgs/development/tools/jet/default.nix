{ lib
, buildGraalvmNativeImage
, fetchurl
, testers
, jet
}:

buildGraalvmNativeImage rec {
  pname = "jet";
  version = "0.7.27";

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-250/1DBNCXlU1b4jjLUUOXI+uSbOyPXtBN1JJRpdmFc=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "-H:Log=registerResource:"
    "--no-fallback"
    "--no-server"
  ];

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = jet;
    command = "jet --version";
  };

  meta = with lib; {
    description = "CLI to transform between JSON, EDN, YAML and Transit, powered with a minimal query language";
    homepage = "https://github.com/borkdude/jet";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    maintainers = with maintainers; [ ericdallo ];
  };
}
