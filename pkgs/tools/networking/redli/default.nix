{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "redli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Tux4GsYG3DlJoV10Ahb+X+8mpkchLchbh+PCgRD0kUA=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "A humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = licenses.asl20;
    maintainers = with maintainers; [ tchekda ];
  };
}
