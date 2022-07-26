{ lib, buildGoModule, fetchFromGitHub, installShellFiles, git, testers, git-town, makeWrapper }:

buildGoModule rec {
  pname = "git-town";
  version = "7.7.0";

  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    rev = "v${version}";
    sha256 = "sha256-FpBEBx2gb33fGDndvZmvG1A61NoJ4Qy4V3YQSb+Ugsc=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  buildInputs = [ git ];

  ldflags =
    let
      modulePath = "github.com/git-town/git-town/v${lib.versions.major version}"; in
    [
      "-s"
      "-w"
      "-X ${modulePath}/src/cmd.version=v${version}"
      "-X ${modulePath}/src/cmd.buildDate=nix"
    ];

  checkInputs = [ git ];
  preCheck =
    let
      skippedTests = [
        "TestGodog"
        "TestRunner_CreateChildFeatureBranch"
        "TestShellRunner_RunStringWith_Dir"
        "TestMockingShell_MockCommand"
        "TestShellRunner_RunStringWith_Input"
      ];
    in
    ''
      HOME=$(mktemp -d)
      # Disable tests requiring local operations
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  postInstall = ''
    installShellCompletion --cmd git-town \
      --bash <($out/bin/git-town completion bash) \
      --fish <($out/bin/git-town completion fish) \
      --zsh <($out/bin/git-town completion zsh)

    wrapProgram $out/bin/git-town --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.tests.version = testers.testVersion {
    package = git-town;
    command = "git-town version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "https://www.git-town.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ allonsy blaggacao ];
  };
}
