{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-aws";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-aws";
    tag = "v${version}";
    hash = "sha256-xHSPkdtK1km5D6b2KqDQQR8xl+FuA3QP2W3ebhLko1U=";
  };

  vendorHash = "sha256-/fAVMeEYSw0PGcVcLGV31Vt51qbT+SaawlVyApO3qww=";

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
