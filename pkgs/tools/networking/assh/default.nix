{ lib
, buildGoModule
, fetchFromGitHub
, openssh
, makeWrapper
}:

buildGoModule rec {
  pname = "assh";
  version = "2.12.1";

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    rev = "v${version}";
    sha256 = "1r3fny4k1crpjasgsp09qf0p3l9vg8c0ddbb8jd6qnqnwwprqfxd";
  };

  vendorSha256 = "14x7m900mxiwgbbxs56pdqsmx56c4qir5j4dz57bwr10rmh25fy4";

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
