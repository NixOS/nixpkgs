{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, openssh
, makeWrapper
, ps
}:

buildGoModule rec {
  pname = "assh";
  version = "2.16.0";

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    rev = "v${version}";
    sha256 = "sha256-rvJJZqVSBdaJ154NV6RaxbymsSsHbKnlJDeR6KHQE7M=";
  };

  vendorHash = "sha256-L2Uo/jsMtxQClF1UDa7NIUbOm7BflvncNsjqGnCsPKo=";

  ldflags = [
    "-s" "-w" "-X moul.io/assh/v2/pkg/version.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = lib.optionals stdenv.isDarwin [ ps ];

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
