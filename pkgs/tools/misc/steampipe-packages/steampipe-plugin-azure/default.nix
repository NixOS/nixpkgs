{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-azure";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-azure";
    tag = "v${version}";
    hash = "sha256-eCUFXgFlC6PJ2SlWJ7dmIq5Kf1+VJErGY258ZYH4HxI=";
  };

  vendorHash = "sha256-CYz76ttMgwS9VfCO/2MQ59bBsOpzOzT39q4ma19x644=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $GOPATH/bin/steampipe-plugin-azure $out/steampipe-plugin-azure.plugin
    cp -R docs $out/.
    cp -R config $out/.

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/turbot/steampipe-plugin-azure/blob/v${version}/CHANGELOG.md";
    description = "Azure Plugin for Steampipe";
    homepage = "https://github.com/turbot/steampipe-plugin-azure";
    license = lib.licenses.apsl20;
    longDescription = "Use SQL to instantly query Azure resources across regions and subscriptions.";
    maintainers = with lib.maintainers; [ petee ];
    platforms = steampipe.meta.platforms;
  };
}
