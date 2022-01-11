{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NkflJwFdVcFTjXkDr8qqAFUlKwGNPTso6hvu7Vikn2U=";
  };

  vendorSha256 = "sha256-RZPfdj+rimKGvRZKaXOirkd7ietri55rBofwa/l2z8s=";

  doCheck = false;

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
