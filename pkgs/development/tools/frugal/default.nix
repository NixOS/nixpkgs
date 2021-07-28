{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.7";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mCfM2G+FhKDwPg0NqLIAe8F5MRZVJ0tcIY9FBuLpRpE=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-onbvW3vjuAL+grLfvJR14jxVpoue+YZAeFMOS8ktS1A=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
