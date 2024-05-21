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
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yEYdFpIIY+nAaeMPEwgz0th2rf67LeYK19Ov9QB/7J0=";
  };

  vendorHash = "sha256-aoc8KSznkWJpn0Ye7FUOH5sNQ4fslIGJhIaQdGrwcqQ=";

  excludedPackages = [ "./e2etests" ];

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=v${version}"
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

  passthru.tests.version = testers.testVersion {
    package = d2;
    version = "v${version}";
  };

  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya kashw2 ];
  };
}
