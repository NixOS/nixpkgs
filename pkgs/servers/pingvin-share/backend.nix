{
  lib,
  buildNpmPackage,
  vips,
  pkg-config,
  prisma,
  src,
  version,
  nixosTests,
}:

buildNpmPackage {
  pname = "pingvin-share-backend";
  inherit version;

  src = "${src}/backend";

  npmInstallFlags = [ "--build-from-source" ];
  installPhase = ''
    cp -r . $out
    ln -s $out/node_modules/.bin $out/bin
  '';

  preBuild = ''
    prisma generate
  '';

  buildInputs = [ vips ];
  nativeBuildInputs = [
    pkg-config
    prisma
  ];

  npmDepsHash = "sha256-zzN4r2hednmm5DFnK/RRTKPq0vWiGhG+WyNTPNNP1vc=";
  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  passthru.tests = {
    pingvin-share = nixosTests.pingvin-share;
  };

  meta = {
    description = "Backend of pingvin-share, a self-hosted file sharing platform";
    homepage = "https://github.com/stonith404/pingvin-share";
    downloadPage = "https://github.com/stonith404/pingvin-share/releases";
    changelog = "https://github.com/stonith404/pingvin-share/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ratcornu ];
  };
}
