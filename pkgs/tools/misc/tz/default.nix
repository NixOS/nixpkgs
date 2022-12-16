{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tz";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "oz";
    repo = "tz";
    rev = "v${version}";
    sha256 = "sha256-fl+Q6HNMSIo6E5SMBkTr6/hJN9akfJRBwSPaq7FcYDY=";
  };

  vendorSha256 = "sha256-lcCra4LyebkmelvBs0Dd2mn6R64Q5MaUWc5AP8V9pec=";

  meta = with lib; {
    description = "A time zone helper";
    homepage = "https://github.com/oz/tz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
