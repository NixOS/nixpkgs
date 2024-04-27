{ lib, buildGoModule, fetchFromGitHub, nixosTests, installShellFiles }:

buildGoModule rec {
  pname = "shiori";
  version = "1.7.0";

  vendorHash = "sha256-fakRqgoEcdzw9WZuubaxfGfvVrMvb8gV/IwPikMnfRQ=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5+hTtvBnj3Nh5HitReVkLift9LTiMYVuuYx5EirN0SA=";
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd shiori \
      --bash <($out/bin/shiori completion bash) \
      --fish <($out/bin/shiori completion fish) \
      --zsh <($out/bin/shiori completion zsh)
  '';

  # passthru.tests.smoke-test = nixosTests.shiori; # test broken

  meta = with lib; {
    description = "Simple bookmark manager built with Go";
    mainProgram = "shiori";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson CaptainJawZ ];
  };
}
