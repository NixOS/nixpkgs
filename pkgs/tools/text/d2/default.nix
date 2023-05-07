{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, git
, testers
, d2
}:

buildGoModule rec {
  pname = "d2";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kfpCu79lJUxPvxSKplRziVnDyohY8xnxnO3ZoG2WgEs=";
  };

  vendorHash = "sha256-oPI6FPfBIPKZDLoyGblcG5UcmoFWufZ2NIEClpSIJzU=";

  excludedPackages = [ "./e2etests" ];

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    # See https://github.com/terrastruct/d2/blob/master/docs/CONTRIBUTING.md#running-tests.
    export TESTDATA_ACCEPT=1
  '';

  passthru.tests.version = testers.testVersion { package = d2; };

  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
