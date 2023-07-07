{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "sha256-Jxg1gaMTJ/BbL8TQfPcyt1hYnT/LcL4j+m+jSeh5QyA=";
  };

  vendorHash = "sha256-yXFIBWOF72nXmT8+OSvF1aKBhCMBloLmGTfvNbV9ir4=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  ldflags = [ "-s" "-w" "-X golift.io/version.Version=${version}" ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
  };
}
