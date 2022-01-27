{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.9.29";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lPw0ndxffBQNsJStrZ9gaGZg+EJcGT9b6xTAc7eX6c8=";
  };

  vendorSha256 = "sha256-4aoDQKMhczy1u4Eq567aMrFVIBW2L8OgNCqsgmUN6CI=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = "https://go.tacodewolff.nl/minify";
  };
}
