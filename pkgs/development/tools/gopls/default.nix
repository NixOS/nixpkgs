{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.7.1";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "0cq8mangcc1fz1ii7v4smxbpzynhwy6gvl80n5hvhjpgkp0k4fsm";
  };

  modRoot = "gopls";
  vendorSha256 = "1mzn1nn3l080lch0yhh4g2sq02g95v14nha8k3d373vwvwg45igs";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 zimbatm ];
  };
}
