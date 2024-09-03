{ lib, buildGraalvmNativeImage, graalvmCEPackages, removeReferencesTo, fetchurl
}:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2024.08.01";

  src = fetchurl {
    url =
      "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-sDEZ3Tk2QRlL8oclV7vUZfdXpEdYCfCT45vP82Dccz4=";
  };

  graalvmDrv = graalvmCEPackages.graalvm-ce;

  nativeBuildInputs = [ removeReferencesTo ];

  extraNativeImageBuildArgs =
    [ "-H:+ReportExceptionStackTraces" "--no-fallback" ];

  postInstall = ''
    remove-references-to -t ${graalvmDrv} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    changelog =
      "https://github.com/clj-kondo/clj-kondo/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ jlesquembre bandresen ];
  };
}
