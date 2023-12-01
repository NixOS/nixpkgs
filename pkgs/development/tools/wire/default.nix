{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wire";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "wire";
    rev = "v${version}";
    sha256 = "sha256-9xjymiyPFMKbysgZULmcBEMI26naUrLMgTA+d7Q+DA0=";
  };

  vendorHash = "sha256-ZFUX4LgPte6oAf94D82Man/P9VMpx+CDNCTMBwiy9Fc=";

  subPackages = [ "cmd/wire" ];

  meta = with lib; {
    homepage = "https://github.com/google/wire";
    description = "A code generation tool that automates connecting components using dependency injection";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
