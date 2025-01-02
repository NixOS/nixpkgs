{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-azure";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-azure";
    rev = "refs/tags/v${version}";
    hash = "sha256-MVLOAD/Ukvg0ox/aFdm1sx/BkS8gmKhexjt0CnUO+s4=";
  };

  vendorHash = "sha256-r/RZ1qcB+bdHS/CeaOko8nu9lOZlOAzqNjG+E8qQNzs=";

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
