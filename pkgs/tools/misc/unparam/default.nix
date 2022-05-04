{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "unparam";
  version = "unstable-2021-12-14";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "unparam";
    rev = "d0ef000c54e5fbf955d67422b0495b9f29b354da";
    sha256 = "sha256-fH/LcshpOk+UFfQ5dE2eHi6Oi5cm8umeXoyHJvhpAbE=";
  };

  vendorSha256 = "sha256-pfIxWvJYAus4DShTcBI1bwn/Q2c5qWvCwPCwfUsv8c0=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Find unused parameters in Go";
    homepage = "https://github.com/mvdan/unparam";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
