{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "redli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nLauKt3OnFZFnFjw0s2kTFdvdYjFkeA6eQwZEhT4n/s=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "A humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = licenses.asl20;
    maintainers = with maintainers; [ tchekda ];
  };
}
