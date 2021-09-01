{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "sha256-OJDFPSXbJffiKW1SmMptPxj69YU7cuOU1LgIiInurCM=";
  };

  vendorSha256 = "sha256-n8gRefr+MyiSaATG1mZrS3lx4oDEfbQ1LQxQ6vp5l0Y=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
  };
}
