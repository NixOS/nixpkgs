{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "0fi9wgv5aj3ds3r5qjyi4pxnd56psrpdy2sz84jd0sz2w48x4k4p";
  };

  vendorSha256 = "11r3vpimhik7y09gwb3p6pl0yf53hpaw24ry4a833fw8060rqp3q";

  buildFlagsArray = ''
    -ldflags=
    -X github.com/mdlayher/corerad/internal/build.linkTimestamp=1590182656
    -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
