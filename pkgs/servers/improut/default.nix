{ lib, buildGoModule, fetchFromGitHub, pkgs }:

buildGoModule rec {
  pname = "improut";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "zopieux";
    repo = pname;
    sha256 = "06wk397fa27fx20s6vvg0q85f2zq500bqqr565fl19j4wgxv8yhm";
    rev = "v${version}";
  };

  vendorSha256 = "0xxcv6nx54g1wpzkrk92i2lpgkxvyddyv160q0gq14mvmn10af4j";

  # Tests rely on a fs with xattr support, which we don't have during build.
  doCheck = false;

  meta = with lib; {
    description = "Dead simple image hosting";
    homepage = "https://github.com/zopieux/improut";
    license = licenses.mit;
    maintainers = with maintainers; [ zopieux ];
  };
}
