{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wire";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "wire";
    rev = "v${version}";
    sha256 = "0fYXo/LnxKV/qoaP59XCyEtLLAysZm/WhRdm3RnLdvw=";
  };

  vendorSha256 = "ZFUX4LgPte6oAf94D82Man/P9VMpx+CDNCTMBwiy9Fc=";

  subPackages = [ "cmd/wire" ];

  meta = with lib; {
    homepage = "https://github.com/google/wire";
    description = "A code generation tool that automates connecting components using dependency injection";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
