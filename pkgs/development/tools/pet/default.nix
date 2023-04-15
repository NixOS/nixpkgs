{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
  };

  vendorSha256 = "sha256-dUvp7FEW09V0xMuhewPGw3TuAic/sD7xyXEYviZ2Ivs=";

  ldflags = [
    "-s" "-w" "-X=github.com/knqyf263/pet/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pet \
      --zsh ./misc/completions/zsh/_pet
  '';

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
