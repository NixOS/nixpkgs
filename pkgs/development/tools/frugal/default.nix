{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.5";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NkzlhxlQISqFmYeO7LttwMWhvL7YblrWREkvnKrpTuA=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-iZl5DWZYecXCirJumnidgEWrqfaz+fvM3udOWOC6Upk=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
