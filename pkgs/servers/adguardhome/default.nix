{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  nixosTests,
}:

buildGoModule rec {
  pname = "adguardhome";
  version = "0.107.62";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${version}";
    hash = "sha256-CqXf19DyDFgSnd/dziUq9Gl1d1V20OWE5MTQMi260Zc=";
  };

  vendorHash = "sha256-lY24TtW4vpMRUzOZmeX3Ip9ikUc4z1HG49DpeECExdk=";

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
