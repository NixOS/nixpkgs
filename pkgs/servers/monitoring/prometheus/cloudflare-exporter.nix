{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule rec {
  pname = "cloudflare-exporter";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "lablabs";
    repo = pname;
    tag = "cloudflare-exporter-${version}";
    sha256 = "sha256-lQltG8T3V7L81bKj4yoP0rHEeBRQWFAZ1e7y/1+UbIM=";
  };

  vendorHash = "sha256-v8qw4Cofw0vOrEg5oo9YtRabXMrjpQ+tI4l+A43JllA=";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "cloudflare-exporter-(.*)"
      ];
    };
  };

  meta = {
    description = "Prometheus Cloudflare Exporter";
    mainProgram = "cloudflare-exporter";
    homepage = "https://github.com/lablabs/cloudflare-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
    platforms = lib.platforms.linux;
  };
}
