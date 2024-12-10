{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-aws";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-aws";
    rev = "refs/tags/v${version}";
    hash = "sha256-VgRt7DODpDqxlkO8oSX948ZpHR6s11LxYYaQZx6St98=";
  };

  vendorHash = "sha256-RM/bsoQTbOj/NKr16GsCQWCxV0f7pYYf2aYcWGghGEQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

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
