{ lib, buildNpmPackage, src, version }:

buildNpmPackage {
  inherit src version;
  pname = "photoprism-frontend";

  postPatch = ''
    cd frontend
  '';

  npmDepsHash = "sha256-v7G06x/6MAFlOPbmkdh9Yt9/0BcMSYXI5EUmIHKiVFo=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ../assets $out/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ benesim ];
  };
}
