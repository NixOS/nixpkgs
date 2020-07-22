{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "oneshot";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "raphaelreyna";
    repo = "oneshot";
    rev = "v${version}";
    sha256 = "14s5cl1g0rgqj7fj699xgz2kmkzym1zpckhv3h33ypsn4dq7gjh2";
  };

  goPackagePath = "github.com/raphaelreyna/oneshot";
  vendorSha256 = "0v53dsj0w959pmvk6v1i7rwlfd2y0vrghxlwkgidw0sf775qpgvy";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A first-come-first-serve single-fire HTTP server";
    homepage = "https://github.com/raphaelreyna/oneshot";
    license = licenses.mit;
    maintainers = with maintainers; [ edibopp ];
    platforms = platforms.all;
  };
}
