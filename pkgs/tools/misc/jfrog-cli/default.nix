{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.56.1";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-oUICnpVHRNCauWEplz7xH6AdP6CbbYX/Uy/QUPjwGHc=";
  };

  vendorHash = "sha256-zQjOOUlqL0Mj2DKHiG9rOfu41SKMO7C99JBJDycXAs4=";

  # Upgrade the Go version during the vendoring FOD build because it fails otherwise.
  overrideModAttrs = _: {
    preBuild = ''
      substituteInPlace go.mod --replace-fail 'go 1.20' 'go 1.21'
    '';
    postInstall = ''
      cp go.mod "$out/go.mod"
    '';
  };

  # Copy the modified go.mod we got from the vendoring process.
  preBuild = ''
    cp vendor/go.mod go.mod
  '';

  postPatch = ''
    # Patch out broken test cleanup.
    substituteInPlace artifactory_test.go \
      --replace-fail \
      'deleteReceivedReleaseBundle(t, "cli-tests", "2")' \
      '// deleteReceivedReleaseBundle(t, "cli-tests", "2")'
  '';

  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  # Some of the tests require a writable $HOME
  preCheck = "export HOME=$TMPDIR";

  nativeCheckInputs = [ nodejs ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/jfrog/jfrog-cli";
    description = "Client for accessing to JFrog's Artifactory and Mission Control through their respective REST APIs";
    changelog = "https://github.com/jfrog/jfrog-cli/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "jf";
    maintainers = with maintainers; [
      detegr
      aidalgol
    ];
  };
}
