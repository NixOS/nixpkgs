{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-github";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-github";
    rev = "refs/tags/v${version}";
    hash = "sha256-BbxgNc+7kC+z9OfCXLEHEG+yC4fQuCHKGOcYSYwxo7U=";
  };

  vendorHash = "sha256-hTQXO34L6frMRZsKbI2hW0PwH77NVFZiVHoTrdkMbBU=";

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
    changelog = "https://github.com/turbot/steampipe-plugin-github/blob/v${version}/CHANGELOG.md";
    description = "GitHub Plugin for Steampipe";
    homepage = "https://github.com/turbot/steampipe-plugin-github";
    license = lib.licenses.apsl20;
    longDescription = "Use SQL to instantly query repositories, users, gists and more from GitHub.";
    maintainers = with lib.maintainers; [ anthonyroussel ];
    platforms = steampipe.meta.platforms;
  };
}
