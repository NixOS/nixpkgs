{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.8";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oCqN9iG4+vBvIJoW1v4ww9SALlhcX5bEgqSjTArPQ2g=";
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
