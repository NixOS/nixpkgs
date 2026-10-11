{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  steampipe,
}:

buildGoModule rec {
  pname = "steampipe-plugin-kubernetes";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe-plugin-kubernetes";
    rev = "refs/tags/v${version}";
    hash = "sha256-EhFCzLHmny2on9EGOEHApkJf+AhU0Bg6FAm2IBLxDZ8=";
  };

  vendorHash = "sha256-oxOLCD5n4Cjdc9Mt2kyec+SBsJWHmwYIyYs9tJPkxcI=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $GOPATH/bin/steampipe-plugin-kubernetes $out/steampipe-plugin-kubernetes.plugin
    cp -R docs $out/.
    cp -R config $out/.

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/turbot/steampipe-plugin-kubernetes/blob/v${version}/CHANGELOG.md";
    description = "Kubernetes Plugin for Steampipe";
    homepage = "https://github.com/turbot/steampipe-plugin-kubernetes";
    license = lib.licenses.asl20;
    longDescription = "Use SQL to instantly query Kubernetes API resources";
    maintainers = with lib.maintainers; [ petee ];
    platforms = steampipe.meta.platforms;
  };
}
