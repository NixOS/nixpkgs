{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.15.1";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pRWTjlPTVwFzamq67hzb+ElqZuqP9aEAVz581DNMUBM=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-ljZ3tpIJ+tg4UDBDzbse4M6ksb8AgPJLJCZeusMtQ0Q=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
