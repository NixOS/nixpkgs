{ lib, buildGraalvmNativeImage, graalvmCEPackages, removeReferencesTo, fetchurl
}:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2023.12.15";

  src = fetchurl {
    url =
      "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-YVFG7eY0wOB41kKJWydXfil8uyDSHRxPVry9L3u2P4k=";
  };

  graalvmDrv = graalvmCEPackages.graalvm-ce;

  nativeBuildInputs = [ removeReferencesTo ];

  extraNativeImageBuildArgs =
    [ "-H:+ReportExceptionStackTraces" "--no-fallback" ];

  postInstall = ''
    remove-references-to -t ${graalvmDrv} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "A linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    changelog =
      "https://github.com/clj-kondo/clj-kondo/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ jlesquembre bandresen ];
  };
}
