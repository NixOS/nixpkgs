{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gojsontoyaml";
  version = "unstable-2020-12-16";

  src = fetchFromGitHub {
    owner = "brancz";
    repo = "gojsontoyaml";
    rev = "202f76bf8c1f8fb74941a845b349941064603185";
    sha256 = "sha256-N49iHQh28nAZBGJnLKG/aZPdn5fwPKQpdrXXtX28yss=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Simply tool to convert json to yaml written in Go";
    homepage = "https://github.com/brancz/gojsontoyaml";
    license = licenses.mit;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
