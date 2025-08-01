{
  src,
  version,
  lib,
  buildNpmPackage,
}:

buildNpmPackage {
  pname = "szurubooru-client";
  inherit version;

  src = "${src}/client";

  npmDepsHash = "sha256-HtcitZl2idgVleB6c0KCTSNLxh7hP8/G/RGdMaQG3iI=";
  makeCacheWritable = true;

  npmBuildFlags = [
    "--gzip"
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv ./public/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Client of szurubooru, an image board engine for small and medium communities";
    homepage = "https://github.com/rr-/szurubooru";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ratcornu ];
  };
}
