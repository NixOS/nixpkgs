{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "1594qrwrz4bc3iipm4aqb8l1zyi04pwmiz0vdlfn12qn1p7lad5p";
  };

  modSha256 = "1cfhxkvwzf7sn227y6h5h19f27a9ngmpnyqdlfba5km8axqn29vm";

  buildFlagsArray = ''
    -ldflags=
    -X github.com/mdlayher/corerad/internal/build.linkTimestamp=1586881022
    -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
