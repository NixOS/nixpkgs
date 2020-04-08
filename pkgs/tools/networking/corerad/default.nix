{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "0nxrksv98mxs5spykhzpydwjzii5cc6gk8az7irs3fdi4jx6pq1w";
  };

  modSha256 = "0vbbpndqwwz1mc59j7liaayxaj53cs8s3javgj3pvhkn4vp65p7c";

  buildFlagsArray = ''
    -ldflags=
    -X github.com/mdlayher/corerad/internal/build.linkTimestamp=1583280117
    -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
