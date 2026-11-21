{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-azure";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-azure";
    tag = "v${version}";
    hash = "sha256-ZhK3geqfYIw4OIYwrFs6aHSSaDfhW/2XC2qy++JlcS8=";
  };

  vendorHash = "sha256-f1PAFWV0K1L1razSrV9Ozp2OeWdu0we/l1v/yJx0hoc=";

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
    license = lib.licenses.asl20;
    longDescription = "Use SQL to instantly query Azure resources across regions and subscriptions.";
    maintainers = [ ];
    platforms = steampipe.meta.platforms;
  };
}
