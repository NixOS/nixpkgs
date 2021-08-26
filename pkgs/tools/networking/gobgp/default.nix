{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgp";
  version = "2.29.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-DhSIf8fAG2Zf0mwJ/iMgQU5sugHK2jJ6WJPbFbA/mhM=";
  };

  vendorSha256 = "sha256-PWm7XnO6LPaU8g8ymmqRkQv2KSX9kLv9RVaa000mrTY=";

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
