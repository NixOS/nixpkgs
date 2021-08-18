{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.9.21";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cHoQtvxofMet7j/PDKlFoVB9Qo5EMWcXqAwhqR4vNko=";
  };

  vendorSha256 = "sha256-awlrjXXX9PWs4dt78yK4qNE1wCaA+tGL45tHQxxby8c=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = "https://go.tacodewolff.nl/minify";
  };
}
