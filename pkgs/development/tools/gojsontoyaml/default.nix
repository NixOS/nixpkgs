{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gojsontoyaml";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "brancz";
    repo = "gojsontoyaml";
    rev = "v${version}";
    sha256 = "sha256-ebxz2uTH7XwD3j6JnsfET6aCGYjvsCjow/sU9pagg50=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Simply tool to convert json to yaml written in Go";
    mainProgram = "gojsontoyaml";
    homepage = "https://github.com/brancz/gojsontoyaml";
    license = licenses.mit;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
