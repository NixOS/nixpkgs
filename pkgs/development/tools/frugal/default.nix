{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.19";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PEWjZeFIEfnAGVsv+oyF4R08FI+LzKBWlrlBmiXhJCQ=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-OnPQZk+VpOx97mSNRx9lGtC03OXGGz9JwUSZYX0Ofkc=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
