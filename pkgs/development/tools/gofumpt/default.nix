{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MHNxJ9DPBWrLkaEEfXOmRqo2h2ugwgZT/SIe7bi3J2E=";
  };

  vendorSha256 = "sha256-LR4W7NKrDP7Ke5NYDZPYorZI77upP5IksBFRFsPnDRc=";

  doCheck = false;

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
