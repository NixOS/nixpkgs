{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "14ird8z8f467spa0kdzjf6lq7pipq7rwxrdk6ppv7y1fxw96qm9x";
  };

  modSha256 = "09q8dh4g4k0y7mrhwyi9py7zdiipmq91j3f32cn635v2xw6zyg2k";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
