{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgp";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "0r7w1c3rh0wnsrhdpzr2fp1aqdqafrb42f2hra6xwwspr092ixq0";
  };

  vendorSha256 = "0dmd4r6x76jn8pyvp47x4llzc2wij5m9lchgyaagcb5sfdgbns9x";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  buildFlagsArray = ''
    -ldflags=
    -s -w -extldflags '-static'
  '';

  subPackages = [ "cmd/gobgp" ];

  meta = with lib; {
    description = "A CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
