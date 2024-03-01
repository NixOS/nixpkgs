{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "sha256-NnnutXVwyWlPO7yJk8BAZJqtNl8sodDx/ZnX+TL8sWs=";
  };

  vendorHash = "sha256-ebdPWKNL9i3sEGpfDCXIfOaFQjV5LXohug2qFXeWenk=";

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
