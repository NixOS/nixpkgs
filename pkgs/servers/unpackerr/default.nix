{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "1jyqrfik6fy7d4lr1y0ryp4iz8yn898ksyxwaryvrhykznqivp0y";
  };

  vendorSha256 = "0ilpg7xfll0c5lsv8zf4h3i72yabddkddih4d292hczyz9wi3j4z";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
  };
}
