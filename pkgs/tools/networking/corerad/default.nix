{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "corerad";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "073hjbwra8ihh11ha5ajqq2r98cc5li4k0xs4p4s055q197zj3aa";
  };

  vendorSha256 = "19hp8xqr50v8h9vblihalvkb9ll8c0v4p071j9j1zkbjhnb07rca";

  buildFlagsArray = ''
    -ldflags=
    -X github.com/mdlayher/corerad/internal/build.linkTimestamp=1593050100
    -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
  '';

  passthru.tests = {
    inherit (nixosTests) corerad;
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
