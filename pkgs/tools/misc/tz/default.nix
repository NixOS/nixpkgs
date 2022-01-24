{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tz";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "oz";
    repo = "tz";
    rev = "v${version}";
    sha256 = "sha256-D0rakLZ+swrDwBMcr+EJPgaYsQTWob50QteW1PoIdNk=";
  };

  vendorSha256 = "sha256-gMHPWf/kFb55GyyMciLWRzvrQXUGDQ72RNkIhkMVe54=";

  meta = with lib; {
    description = "A time zone helper";
    homepage = "https://github.com/oz/tz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
