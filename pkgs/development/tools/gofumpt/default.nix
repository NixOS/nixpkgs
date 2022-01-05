{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kgj3f90bAtaVl4mby6FQr4t4BT4I3QLtHhvO10f1BOk=";
  };

  vendorSha256 = "sha256-gxxK2eUmYUqHjt8HP6OANaHsO43wCaodUDR4BlMY8Zw=";

  doCheck = false;

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
