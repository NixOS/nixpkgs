{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.9.22";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ph5PrM917qGwp7SLg6Ujfk5YJWFSlUBdW/JJRiwq7fw=";
  };

  vendorSha256 = "sha256-0GKIGIVtMywpKxopsVrUZMgeXP/l76U2As8FiG2Niqw=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = "https://go.tacodewolff.nl/minify";
  };
}
