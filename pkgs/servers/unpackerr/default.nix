{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "sha256-boDDxQVEUnPOt+ido8J1MvkVUrZRusdSORY0/mPfjDw=";
  };

  vendorHash = "sha256-rxoAHcVxjKII945FQ4/HD3UjtZTwmlFx8zJx0Rfumu4=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  ldflags = [ "-s" "-w" "-X golift.io/version.Version=${version}" ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = [ ];
    license = licenses.mit;
    mainProgram = "unpackerr";
  };
}
