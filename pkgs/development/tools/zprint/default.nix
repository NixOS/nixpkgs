{ lib
, buildGraalvmNativeImage
, fetchurl
, testers
, zprint
}:

buildGraalvmNativeImage rec {
  pname = "zprint";
  version = "1.2.8";

  src = fetchurl {
    url = "https://github.com/kkinnear/${pname}/releases/download/${version}/${pname}-filter-${version}";
    sha256 = "sha256-o0yoW45a5r+sTGvjEqr5VZgQKm72qsPH/kbLTbMTgEM=";
  };

  extraNativeImageBuildArgs = [
    "--no-server"
    "-H:EnableURLProtocols=https,http"
    "-H:+ReportExceptionStackTraces"
    "--report-unsupported-elements-at-runtime"
    "--initialize-at-build-time"
    "--no-fallback"
  ];

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = zprint;
    command = "zprint --version";
  };

  meta = with lib; {
    description = "Clojure/EDN source code formatter and pretty printer";
    longDescription = ''
      Library and command line tool providing a variety of pretty printing capabilities
      for both Clojure code and Clojure/EDN structures. It can meet almost anyone's needs.
      As such, it supports a number of major source code formatting approaches
    '';
    homepage = "https://github.com/kkinnear/zprint";
    license = licenses.mit;
    maintainers = with maintainers; [ stelcodes ];
    mainProgram = "zprint";
  };
}
