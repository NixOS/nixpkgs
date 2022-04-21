{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "devspace";
  version = "5.18.4";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "devspace";
    rev = "v${version}";
    sha256 = "0s5117cgxgrxfki5drvg6d22dvrjffa03bi644zdl1p631r599r1";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with lib; {
    description = "DevSpace is an open-source developer tool for Kubernetes that lets you develop and deploy cloud-native software faster";
    homepage = "https://devspace.sh/";
    changelog = "https://github.com/loft-sh/devspace/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ darkonion0 ];
  };
}
