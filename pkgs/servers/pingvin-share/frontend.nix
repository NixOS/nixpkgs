{ lib
, buildNpmPackage
, vips
, pkg-config
, src
, version
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

  npmDepsHash = "sha256-C0YKbiZzdj8HIGM3ivQ9+KhGsC5IfVz54ZhKZmlXcoA=";
  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    description = "The frontend of pingvin-share, a self-hosted file sharing platform and an alternative for WeTransfer.";
    homepage = "https://github.com/stonith404/pingvin-share";
    downloadPage = "https://github.com/stonith404/pingvin-share/releases";
    changelog = "https://github.com/stonith404/pingvin-share/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ratcornu ];
  };
}
