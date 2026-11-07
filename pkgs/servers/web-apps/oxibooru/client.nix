{
  src,
  version,
  lib,
  buildNpmPackage,
}:

buildNpmPackage {
  pname = "oxibooru-client";
  inherit version;

  src = "${src}/client";

  npmDepsHash = "sha256-Cn45jyRkQPkqc9XgqvTvXT2yOjG8uEag1KGwXJ/7GnQ=";
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

  meta = {
    description = "Client of Oxibooru, an image board engine based on Szurubooru";
    homepage = "https://github.com/liamw1/oxibooru";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ratcornu ];
  };
}
