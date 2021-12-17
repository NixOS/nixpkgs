{ buildGoModule, fetchFromGitHub, lib, installShellFiles, git, makeWrapper}:

buildGoModule rec {
  pname = "mani";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "alajmo";
    repo = "mani";
    rev = "v${version}";
    sha256 = "sha256-9rcgPeYFHdIN73K0zGPEHqFFLFkVYkNYRXJ+0/Zo4zI=";
  };

  vendorSha256 = "sha256-ZivzDfjx2djzS0Xm3GISK3zpB5fUUMgy2o4Ti1Z9wMM=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postInstall = ''
    installShellCompletion --cmd mani \
      --bash <($out/bin/mani completion bash) \
      --fish <($out/bin/mani completion fish) \
      --zsh <($out/bin/mani completion zsh)

    wrapProgram $out/bin/mani \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  # Skip tests
  # The repo's test folder has a README.md with detailed information. I don't
  # know how to wrap the dependencies for these integration tests so skip for now.
  doCheck = false;

  meta = with lib; {
    description = "CLI tool to help you manage multiple repositories";
    longDescription = ''
      mani is a CLI tool that helps you manage multiple repositories. It's useful
      when you are working with microservices, multi-project systems, many
      libraries or just a bunch of repositories and want a central place for
      pulling all repositories and running commands over them.
    '';
    homepage = "https://manicli.com/";
    changelog = "https://github.com/alajmo/mani/releases/tag/v${version}";
    license = licenses.mit;
  };
}
