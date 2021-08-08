{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0-rc.3";
  vendorSha256 = "sha256-sXUbfxhPmJXO+KgV/dmWmsyV49Pb6CoJLbt50yVgEvI=";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "sha256-YXdCTK9/eMvcHWg7gQQiPlLWYx2OjbOJDDNdSYO09HU=";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
