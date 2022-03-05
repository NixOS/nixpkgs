{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.29";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q1T+bDOOPs4eLnRWkYG6VY0AwfG/W2boSY5DZhMv+ZI=";
  };

  vendorSha256 = "sha256-YTvgofZoWGDZL/ujjZ9RqAgv6UH2caZBrV9/uav3KVw=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
