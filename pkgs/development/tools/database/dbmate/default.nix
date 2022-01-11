{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "sha256-XNxy8CnhO3rQi3VHr7nikFNXvY2eM30jR0ngNc0FV3E=";
  };

  vendorSha256 = "sha256-Qe3fwyEf/NiGmUSha/zZHRBR1okw2vE97u7tybqiWNI=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
