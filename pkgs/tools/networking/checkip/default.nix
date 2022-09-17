{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.40.3";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XUSEmRd7wUN9b3QaVZtIfugw4hXpB4Nc9qk3m1NQS0o=";
  };

  vendorSha256 = "sha256-bFhSMjm9rqUUbCV9keeXm+yhzQMKrYKs1DbCt53J8aM=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
