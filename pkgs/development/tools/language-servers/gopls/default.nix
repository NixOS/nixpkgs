{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-E/QX3J/ux7GAG93b1K7OdDjYBAzte2HMa6bfALtXgcU=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-e83y8bu0xKGEg7o2BWt4CzM2YosLDefFRgTfA0f3ZmI=";

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
