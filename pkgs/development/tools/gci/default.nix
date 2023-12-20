{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-75ye/624fDcWCn+H0gAYHRPcVUh+JJm3vU6T4w1T0jM=";
  };

  vendorHash = "sha256-bPRcOvwbWEpcJUlIqQNeoYME4ky0YE5LlyWhSTWCIHQ=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [krostar];
  };
}
