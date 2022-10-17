{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fr9x9QA82wybfsnO/nXPgRBPmNgCBO0Rx+AosBV8Its=";
  };

  vendorSha256 = "sha256-tFrwrpUIc7BnNJe8BBn+jmEeYTekBwEz0GAkHxLUcnU=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
  };
}
