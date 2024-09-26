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

  npmDepsHash = "sha256-Uw2mjg8H+7XTm6SjfYHYkP7MJl8kdJXDKBFcx6VffPs=";
  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  passthru.tests = {
    pingvin-share = nixosTests.pingvin-share;
  };

  meta = with lib; {
    description = "Backend of pingvin-share, a self-hosted file sharing platform";
    homepage = "https://github.com/stonith404/pingvin-share";
    downloadPage = "https://github.com/stonith404/pingvin-share/releases";
    changelog = "https://github.com/stonith404/pingvin-share/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ratcornu ];
  };
}
