{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-49TDAxFx4kSwCn1YGQgMn3xLG3RHCCttMzqUfm4OPtE=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-1/stMvxsCs2OPMN7KGbZ61s2qGT5Yg7kHVHsWi6ekcY=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
  };
}
