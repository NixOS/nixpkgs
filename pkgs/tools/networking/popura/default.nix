{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "popura";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "${pname}-network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iCu6/vD4vgn7aGdwK+OB8ib/QwUwoFuxDUs7vqbTZQc=";
  };

  vendorHash = "sha256-9lQC35yt1S2uch3qgwNfa/1FHy+Qi1D5Jo7DWNMgU9w=";

  ldflags =
    let
      pkgSrc = "github.com/yggdrasil-network/yggdrasil-go/src/version";
    in
    [
      "-s"
      "-w"
      "-X=${pkgSrc}.buildName=yggdrasil"
      "-X=${pkgSrc}.buildVersion=${version}"
    ];

  meta = with lib; {
    description = "An alternative Yggdrasil network client";
    homepage = "https://github.com/popura-network/popura";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "yggdrasil";
  };
}
