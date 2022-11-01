{ lib, buildGoModule, fetchFromGitHub, stdenv, makeWrapper, gitMinimal }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hDVn7ZiZoY0FSgIsApZliMIq1xjuNdg+DMvKzP5kET0=";
  };
  vendorSha256 = "sha256-5hVcul5DlHZ0Gtw1LdBmxGpsmuD2bTtwPGysOUwe2k0=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${version}" ];

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    done
  '';

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse ];
  };
}
