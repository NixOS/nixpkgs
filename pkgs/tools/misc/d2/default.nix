{ lib
, buildGoModule
, fetchFromGitHub
, git
, testers
, d2
}:

buildGoModule rec {
  pname = "d2";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2abGQmgwqxWFk7NScdgfEjRYZF2rw8kxTKRwcl2LRg0=";
  };

  vendorHash = "sha256-/BEl4UqOL4Ux7I2eubNH2YGGl4DxntpI5WN9ggvYu80=";

  nativeBuildInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=${version}"
  ];

  excludedPackages = [ "./e2etests/report" ];

  preCheck =
    let
      skippedTests = [
        "TestCompile"
        "TestExport"
        "TestDelete"
        "TestMove"
        "TestSet"
        "TestE2E"
      ];
    in
    ''
      # Disable flaky tests
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  passthru.tests.version = testers.testVersion { package = d2; };

  meta = with lib; {
    homepage = "https://d2lang.com/";
    description = "A modern diagram scripting language that turns text to diagrams";
    license = licenses.mpl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
