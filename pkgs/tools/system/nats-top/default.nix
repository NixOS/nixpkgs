{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nats-top";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G2rUN+eFYWz78xDJcwYVtooTtNSNWR2nUTzar5ztWwE=";
  };

  vendorSha256 = "sha256-UOy3kyKtOXADdyoZ2rVgIQEOPs2oPBkMTYXxfQzVFmc=";

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
