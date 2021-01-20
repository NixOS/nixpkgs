{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gojsontoyaml";
  version = "unstable-2020-06-02";

  src = fetchFromGitHub {
    owner = "brancz";
    repo = "gojsontoyaml";
    rev = "3697ded27e8cfea8e547eb082ebfbde36f1b5ee6";
    sha256 = "07sisadpfnzbylzirs5ski8wl9fl18dm7xhbv8imw6ksxq4v467a";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Simply tool to convert json to yaml written in Go";
    homepage = "https://github.com/brancz/gojsontoyaml";
    license = licenses.mit;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
