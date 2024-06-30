{ lib
, buildNpmPackage
, vips
, pkg-config
, nodePackages
, src
, version
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
  nativeBuildInputs = [ pkg-config nodePackages.prisma ];

  npmDepsHash = "sha256-eHHK30lZnF9As2NFXCHwoEKrfHI5vyo12OWyDDHdsYM=";
  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    description = "Backend of pingvin-share, a self-hosted file sharing platform";
    homepage = "https://github.com/stonith404/pingvin-share";
    downloadPage = "https://github.com/stonith404/pingvin-share/releases";
    changelog = "https://github.com/stonith404/pingvin-share/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ratcornu ];
  };
}
