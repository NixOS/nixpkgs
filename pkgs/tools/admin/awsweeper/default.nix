{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

buildGoModule rec {
  pname = "awsweeper";
  version = "0.7.0";

  # Requires go generate to be run with mockgen, but doesn't check in the results.
  patches = fetchurl {
    url = "https://raw.githubusercontent.com/c00w/patches/master/awskeeper.patch";
    sha256 = "0dz553ffxc37m2iwygrbhxf7pm91hxdriic8a1gjf8q3nyn13npl";
  };

  src = fetchFromGitHub {
    owner = "cloudetc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ybrrpnp6rh7rcwihww43cvhfhzzyy51rdk1hwy9ljpkg37k4y28";
  };

  vendorSha256 = "0hnpb1xp135z2qpn1b6xad59739hffhs8dfpr3n5drmrvajpn4xp";

  meta = with lib; {
    description = "A tool to clean out your AWS account";
    homepage = "https://github.com/cloudetc/awsweeper/";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
