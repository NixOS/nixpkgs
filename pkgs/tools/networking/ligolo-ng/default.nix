{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "refs/tags/v${version}";
    hash = "sha256-TNIAin4W3pBNl9Id0zFeEDTT0B2PCS29q7csekkZ4CQ=";
  };

  vendorHash = "sha256-LqoWkhEnsKTz384dhqNKmZrG38NHxaFx4k7zjHj51Ys=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tunneling/pivoting tool that uses a TUN interface";
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    changelog = "https://github.com/nicocha30/ligolo-ng/releases/tag/v${version}";
    license = licenses.gpl3Only;
  };
}
