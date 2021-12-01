{ lib
, buildGoModule
, fetchFromGitHub
, openssh
, makeWrapper
}:

buildGoModule rec {
  pname = "assh";
  version = "2.12.0";

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    rev = "v${version}";
    sha256 = "sha256-FqxxNTsZVmCsIGNHRWusFP2gba2+geqBubw+6PeR75c=";
  };

  vendorSha256 = "sha256-AYBwuRSeam5i2gex9PSG9Qk+FHdEhIpY250CJo01cFE=";

  doCheck = false;

  ldflags = [
    "-s" "-w" "-X moul.io/assh/v2/pkg/version.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/assh" \
      --prefix PATH : ${openssh}/bin
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/assh --help > /dev/null
  '';

  meta = with lib; {
    description = "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts";
    homepage = "https://github.com/moul/assh";
    changelog = "https://github.com/moul/assh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zzamboni ];
    platforms = with platforms; linux ++ darwin;
  };
}
