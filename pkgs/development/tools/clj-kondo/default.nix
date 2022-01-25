{ lib, buildGraalvmNativeImage, fetchurl }:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2022.01.15";

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-s1SdCy4GaxFL9M3Fp/WGu1C6qY2Kst5PXFShrGCizUE=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
  ];

  meta = with lib; {
    description = "A linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    license = licenses.epl10;
    changelog = "https://github.com/clj-kondo/clj-kondo/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ jlesquembre bandresen thiagokokada ];
  };
}
