{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  nixosTests,
}:

buildGoModule rec {
  pname = "adguardhome";
  version = "0.107.63";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${version}";
    hash = "sha256-yu+rw1is5Egs1O2mww8MGe48Cl74j7RULm4FB2JhQN4=";
  };

  vendorHash = "sha256-9w2P3kNSf8I6tGq3K0ULoV+qeq3rUzrevDC+mktfsis=";

  dashboard = buildNpmPackage {
    inherit src;
    name = "dashboard";
    postPatch = ''
      cd client
    '';
    npmDepsHash = "sha256-s7TJvGyk05HkAOgjYmozvIQ3l2zYUhWrGRJrWdp9ZJQ=";
    npmBuildScript = "build-prod";
    postBuild = ''
      mkdir -p $out/build/
      cp -r ../build/static/ $out/build/
    '';
  };

  preBuild = ''
    cp -r ${dashboard}/build/static build
  '';

  passthru = {
    updateScript = ./update.sh;
    schema_version = 29;
    tests.adguardhome = nixosTests.adguardhome;
  };

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    maintainers = with maintainers; [
      numkem
      iagoq
      rhoriguchi
      baksa
    ];
    license = licenses.gpl3Only;
    mainProgram = "AdGuardHome";
  };
}
