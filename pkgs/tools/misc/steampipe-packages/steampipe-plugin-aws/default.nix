{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-aws";
  version = "0.132.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-aws";
    rev = "refs/tags/v${version}";
    hash = "sha256-JFObV4DhJi4V0mKaKC40J8EzBzjRmOsq+KqXzPJuPMo=";
  };

  vendorHash = "sha256-p2aPHevcY3JK7Qb4KiUjemM4Js4k35DME7BVu1QpE6s=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $GOPATH/bin/${pname} $out/${pname}.plugin
    cp -R docs $out/.
    cp -R config $out/.

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/turbot/steampipe-plugin-aws/blob/v${version}/CHANGELOG.md";
    description = "AWS Plugin for Steampipe";
    homepage = "https://github.com/turbot/steampipe-plugin-aws";
    license = lib.licenses.apsl20;
    longDescription = "Use SQL to instantly query AWS resources across regions and accounts.";
    maintainers = with lib.maintainers; [ anthonyroussel ];
    platforms = steampipe.meta.platforms;
  };
}
