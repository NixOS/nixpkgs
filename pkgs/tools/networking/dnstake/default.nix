{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dnstake";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pwnesia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k6j7DIwK8YAKmEjn8JJO7XBcap9ui6cgUSJG7CeHAAM=";
  };

  vendorSha256 = "sha256-l3IKvcO10C+PVDX962tFWny7eMNC48ATIVqiHjpVH/Y=";

  meta = with lib; {
    description = "Tool to check missing hosted DNS zones";
    homepage = "https://github.com/pwnesia/dnstake";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
