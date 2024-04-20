{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "script_exporter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "adhocteam";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t/xgRalcHxEcT1peU1ePJUItD02rQdfz1uWpXDBo6C0=";
  };

  vendorHash = "sha256-Hs1SNpC+t1OCcoF3FBgpVGkhR97ulq6zYhi8BQlgfVc=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) script; };

  meta = with lib; {
    description = "Shell script prometheus exporter";
    mainProgram = "script_exporter";
    homepage = "https://github.com/adhocteam/script_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
  };
}
