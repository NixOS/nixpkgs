{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-aws";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-aws";
    tag = "v${version}";
    hash = "sha256-KLae5Nres29banGy8wVLbwIvaeB9iUBsMtWymS7su54=";
  };

  vendorHash = "sha256-ddU04KqMH/3bLqnaLbKKwPC87FbljKYBNZdyX0njJHM=";

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
