{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pingu";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "sheepla";
    repo = "pingu";
    rev = "v${version}";
    sha256 = "sha256-KYCG3L5x0ZdcyseffB0GoKpLZ/VG/qjMDh10qrLn62Y=";
  };

  vendorSha256 = "sha256-HkESF/aADGPixOeh+osFnjzhpz+/4NIsJOjpyyFF9Eg=";

  meta = with lib; {
    description = "Ping command implementation in Go but with colorful output and pingu ascii art";
    homepage = "https://github.com/sheepla/pingu/";
    license = licenses.mit;
    maintainers = with maintainers; [ CactiChameleon9 ];
  };
}
