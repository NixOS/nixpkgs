{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "sha256-lQqa1YtMLsCEfiC3Ld+lw4SvAD8wctSGi2YdXt9lrTA=";
  };

  vendorSha256 = "sha256-W9lTIjntaNZSJVt6Jow8uSew+zCaGWU9qzseClNiVUI=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  ldflags = [ "-s" "-w" "-X golift.io/version.Version=${version}" ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
  };
}
