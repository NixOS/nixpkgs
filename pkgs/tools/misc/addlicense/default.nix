{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "addlicense";
  version = "unstable-2021-04-22";

  src = fetchFromGitHub {
    owner = "google";
    repo = "addlicense";
    rev = "13e73a7f8fcb5696256b6a7b7addabf1070ad4b9";
    sha256 = "sha256-UiJaTWCBup/Ub9NZIvkb67TvcUllV/AmYAKVO4egRqc=";
  };

  vendorSha256 = "sha256-2mncc21ecpv17Xp8PA9GIodoaCxNBacbbya/shU8T9Y=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ensures source code files have copyright license headers by scanning directory patterns recursively";
    homepage = "https://github.com/google/addlicense";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
