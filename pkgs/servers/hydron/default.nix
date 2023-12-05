{ lib
, buildGoModule
, fetchFromGitHub
, gitUpdater
, pkg-config
, ffmpeg_4
}:

buildGoModule rec {
  pname = "hydron";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "v${version}";
    hash = "sha256-Q1pZf5FPQw+pHItcZyOGx0N+iHmz9rW0+ANFsketh6E=";
  };

  vendorHash = "sha256-fyGC6k9/xER5GwVelBhy5C5tiq6NMhwSmYjSpvenrfA=";
  proxyVendor = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg_4 ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/bakape/hydron";
    description = "High performance media tagger and organizer";
    license = with licenses; [ lgpl3Plus ];
    knownVulnerabilities = [ "CVE-2023-4863" ];  # Via https://github.com/chai2010/webp dep
    maintainers = with maintainers; [ Madouura ];
  };
}
