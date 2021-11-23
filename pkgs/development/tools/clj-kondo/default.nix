{ lib, buildGraalvmNativeImage, fetchurl }:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2021.10.19";

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-i0OeQPZfQPUeXC/Bs84I91IahBKK6W1mFix97s8/lVA=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--verbose"
    "--no-fallback"
  ];

  meta = with lib; {
    description = "A linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    license = licenses.epl10;
    maintainers = with maintainers; [ jlesquembre bandresen thiagokokada ];
  };
}
