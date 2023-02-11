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
  version = "2.15.0";

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    rev = "v${version}";
    sha256 = "sha256-gti2W1y0iFNyDxKjS7joJn3FkZ9AadYsImu4VEdErS4=";
  };

  vendorSha256 = "sha256-xh/ndjhvSz0atJqOeajAm4nw5/TmMrOdOgTauKAsAcA=";

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
