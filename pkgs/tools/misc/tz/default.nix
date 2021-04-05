{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tz";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "oz";
    repo = "tz";
    rev = "v${version}";
    sha256 = "sha256-OwjhV3n1B1yQTNYm4VOW500t0524g85YYiOAAu9yPeo=";
  };

  vendorSha256 = "sha256-Soa87I7oMa34LjYKxNAz9Limi0kQ6JUtb/zI4G7yZnw=";

  meta = with lib; {
    description = "A time zone helper";
    homepage = "https://github.com/oz/tz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
