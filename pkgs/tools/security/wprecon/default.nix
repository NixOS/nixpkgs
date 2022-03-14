{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wprecon";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "blackbinn";
    repo = pname;
    rev = version;
    sha256 = "sha256-OhONubkV6NeQqmZ5a5QeCXSdiLCqskFiuQKGRO/Cal8=";
  };

  vendorSha256 = "sha256-FYdsLcW6FYxSgixZ5US9cBPABOAVwidC3ejUNbs1lbA=";

  meta = with lib; {
    description = "WordPress vulnerability recognition tool";
    homepage = "https://github.com/blackbinn/wprecon";
    # License Zero Noncommercial Public License 2.0.1
    # https://github.com/blackbinn/wprecon/blob/master/LICENSE
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ fab ];
    broken = true; # build fails, missing tag
  };
}
