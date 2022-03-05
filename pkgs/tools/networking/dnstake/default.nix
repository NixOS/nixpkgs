{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dnstake";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "pwnesia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XfZDRu1UrH5nVh1GQCQVaEamKorWSOxQZs556iDqfS8=";
  };

  vendorSha256 = "sha256-l3IKvcO10C+PVDX962tFWny7eMNC48ATIVqiHjpVH/Y=";

  meta = with lib; {
    description = "Tool to check missing hosted DNS zones";
    homepage = "https://github.com/pwnesia/dnstake";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
