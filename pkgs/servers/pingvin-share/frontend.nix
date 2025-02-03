{
  lib,
  buildNpmPackage,
  vips,
  pkg-config,
  src,
  version,
  nixosTests,
}:

buildNpmPackage {
  pname = "pingvin-share-frontend";
  inherit version;

  src = "${src}/frontend";

  npmInstallFlags = [ "--build-from-source" ];
  installPhase = ''
    cp -r . $out
    ln -s $out/node_modules/.bin $out/bin
  '';

  buildInputs = [ vips ];
  nativeBuildInputs = [ pkg-config ];

  npmDepsHash = "sha256-iw7IoEjiLUiDuK9AKI7jXDaUVT6FklmZuZ+CKDig3tE=";
  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  passthru.tests = {
    pingvin-share = nixosTests.pingvin-share;
  };

  meta = with lib; {
    description = "Frontend of pingvin-share, a self-hosted file sharing platform";
    homepage = "https://github.com/stonith404/pingvin-share";
    downloadPage = "https://github.com/stonith404/pingvin-share/releases";
    changelog = "https://github.com/stonith404/pingvin-share/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ratcornu ];
  };
}
