{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "oneshot";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "raphaelreyna";
    repo = "oneshot";
    rev = "v${version}";
    sha256 = "047mncv9abs4xj7bh9lhc3wan37cldjjyrpkis7pvx6zhzml74kf";
  };

  vendorSha256 = "1cxr96yrrmz37r542mc5376jll9lqjqm18k8761h9jqfbzmh9rkp";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A first-come-first-serve single-fire HTTP server";
    homepage = "https://github.com/raphaelreyna/oneshot";
    license = licenses.mit;
    maintainers = with maintainers; [ edibopp ];
  };
}
