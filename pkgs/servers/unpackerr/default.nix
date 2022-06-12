{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "sha256-o+dE3SX+Q+nhxUO4biEluLEeQhsZgzjXdWTdQcw/H2o=";
  };

  vendorSha256 = "sha256-vo5Saq0QEEKi3/0ZXuQDtlMmEIPwshYHHr8h24cD0sI=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  ldflags = [ "-s" "-w" "-X golift.io/version.Version=${version}" ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
  };
}
