{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "sha256-uQwpdgV6ksouW9JTuiiuQjxBGOE/ypDW769kNJgWrHw=";
  };

  vendorHash = "sha256-wWIw0gNn5tqRq0udzPy/n2OkiIVESpSotOSn2YlBNS4=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa WebKit ];

  ldflags = [ "-s" "-w" "-X golift.io/version.Version=${version}" ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = [ ];
    license = licenses.mit;
    mainProgram = "unpackerr";
  };
}
