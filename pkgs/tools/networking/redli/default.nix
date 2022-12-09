{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "redli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AeIGlRsUWK6q0GJJFmvJwpuGy312VPsMhkxMqDDzay4=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "A humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = licenses.asl20;
    maintainers = with maintainers; [ tchekda ];
  };
}
