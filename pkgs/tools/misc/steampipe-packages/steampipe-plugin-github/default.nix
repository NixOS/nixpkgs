{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-github";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-github";
    tag = "v${version}";
    hash = "sha256-Xz8sUCfxKDEN14bVBzPLO7OVAZjXrdreeCK0IOtuA20=";
  };

  vendorHash = "sha256-vZDXLfo9EtPKSLE8hHA5lR/RgJtWESdOqOjpFywXKbs=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $GOPATH/bin/steampipe-plugin-github $out/steampipe-plugin-github.plugin
    cp -R docs $out/.
    cp -R config $out/.

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/turbot/steampipe-plugin-github/blob/v${version}/CHANGELOG.md";
    description = "GitHub Plugin for Steampipe";
    homepage = "https://github.com/turbot/steampipe-plugin-github";
    license = lib.licenses.asl20;
    longDescription = "Use SQL to instantly query repositories, users, gists and more from GitHub.";
    maintainers = with lib.maintainers; [ anthonyroussel ];
    platforms = steampipe.meta.platforms;
  };
}
