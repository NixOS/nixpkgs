{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gotags";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "jstemmer";
    repo = pname;
    rev = "4c0c4330071a994fbdfdff68f412d768fbcca313";
    sha256 = "sha256-cHTgt+zW6S6NDWBE6NxSXNPdn84CLD8WmqBe+uXN8sA=";
  };

  goPackagePath = "github.com/jstemmer/gotags";

  meta = with lib; {
    description = "ctags-compatible tag generator for Go";
    homepage = "https://github.com/jstemmer/gotags";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
