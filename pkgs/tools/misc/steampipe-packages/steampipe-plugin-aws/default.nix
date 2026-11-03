{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-aws";
  version = "1.34.1";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-aws";
    tag = "v${version}";
    hash = "sha256-VM82348h5EYzV6cZwjm+MG9sd2uPjKOsurlrhC7oxxs=";
  };

  vendorHash = "sha256-Hwb0xq2jbE14dFijFUEDAxxsqzdaIox2NxaPjNu0tBc=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  checkFlags =
    let
      # Requires network access
      skippedTests = [
        "TestEndpointUrlSignsWithConnectionKeys"
        "TestEndpointUrlUsesConnectionProfile"
        "TestEndpointUrlAssumesRoleAtConnectionEndpoint"
        "TestEndpointUrlBeatsServiceEndpointEnv"
        "TestEndpointUrlFromEnvWhenNotConfigured"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $GOPATH/bin/steampipe-plugin-aws $out/steampipe-plugin-aws.plugin
    cp -R docs $out/.
    cp -R config $out/.

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/turbot/steampipe-plugin-aws/blob/v${version}/CHANGELOG.md";
    description = "AWS Plugin for Steampipe";
    homepage = "https://github.com/turbot/steampipe-plugin-aws";
    license = lib.licenses.asl20;
    longDescription = "Use SQL to instantly query AWS resources across regions and accounts.";
    maintainers = with lib.maintainers; [ anthonyroussel ];
    platforms = steampipe.meta.platforms;
  };
}
