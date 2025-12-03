{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule rec {
  pname = "cloudflare-exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lablabs";
    repo = pname;
    tag = "cloudflare-exporter-${version}";
    sha256 = "sha256-rfnAGBuY6HoWzZkYp9u+Ee3xhWb6Se2RkkSIWBvjUYY=";
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
