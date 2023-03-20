{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pcstat";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "tobert";
    repo = "pcstat";
    rev = "v${version}";
    sha256 = "sha256-rN6oqhvrzMBhwNLm8+r4rZWZYZUhOq2h764KVhSycNo=";
  };

  vendorSha256 = "sha256-1y6rzarkFNX8G4E9FzCLfWxULbdNYK3DeelNCJ+7Y9Q=";

  meta = with lib; {
    description = "Page Cache stat: get page cache stats for files on Linux";
    homepage = "https://github.com/tobert/pcstat";
    license = licenses.asl20;
    maintainers = with maintainers; [ aminechikhaoui ];
  };
}
