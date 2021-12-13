{ lib, buildGraalvmNativeImage, fetchurl }:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2021.12.01";

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-AH2MAz++jjBNHWAsUOWkfdzyWzGfmcDBNKcJp4xbPxQ=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
  ];

  meta = with lib; {
    description = "A linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    license = licenses.epl10;
    changelog = "https://github.com/clj-kondo/clj-kondo/blob/v${versiont}/CHANGELOG.md";
    maintainers = with maintainers; [ jlesquembre bandresen thiagokokada ];
  };
}
