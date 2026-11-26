{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule (finalAttrs: {
  pname = "steampipe-plugin-aws";
  version = "1.37.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-aws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eAqaBCQszj85c5rSQr/WxQ8uH5y9fGDjMlyhDGHD7mM=";
  };

  vendorHash = "sha256-pao/OCYu0+1HOurH6nNiNRIbTE2XWEAWKKtAdS6WMfQ=";

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
