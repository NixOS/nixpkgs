{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule (finalAttrs: {
  pname = "steampipe-plugin-aws";
  version = "1.35.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-aws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L0VzkFSCj4zpMRxII6v8sQWFPT8PjTPMLtlI5mBL16M=";
  };

  vendorHash = "sha256-UcaGfgrEl6TQph5VEK1dq4vl/jftgPK4KpDXP83b0ck=";

  ldflags = [
    "-s"
    "-w"
  ];

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
    changelog = "https://github.com/turbot/steampipe-plugin-aws/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "AWS Plugin for Steampipe";
    homepage = "https://github.com/turbot/steampipe-plugin-aws";
    license = lib.licenses.asl20;
    longDescription = "Use SQL to instantly query AWS resources across regions and accounts.";
    maintainers = with lib.maintainers; [ anthonyroussel ];
    platforms = steampipe.meta.platforms;
  };
})
