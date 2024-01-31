{ lib
, buildNpmPackage
, vips
, pkg-config
, nodePackages
, src
, version
}:

let
  prisma = nodePackages.prisma;
in

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
  nativeBuildInputs = [ pkg-config prisma ];


  npmDepsHash = "sha256-rXksLrT/WCy7ESEBNeKes+CxBdjmV6uZO24Rkf1urbk=";
  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    description = "The backend of pingvin-share, a self-hosted file sharing platform and an alternative for WeTransfer.";
    homepage = "https://github.com/stonith404/pingvin-share";
    downloadPage = "https://github.com/stonith404/pingvin-share/releases";
    changelog = "https://github.com/stonith404/pingvin-share/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ratcornu ];
  };
}
