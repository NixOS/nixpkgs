{ buildGoModule, fetchFromGitHub, lib, installShellFiles, git, makeWrapper}:

buildGoModule rec {
  pname = "mani";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "alajmo";
    repo = "mani";
    rev = "v${version}";
    sha256 = "sha256-sjudHGqSCgwafyT8alrGvTdC3yM2zmbRcYshxSm23Ko=";
  };

  vendorSha256 = "sha256-NnXQAf8m2cGLvwSOzQWXffiG1zyVqDPQnGAeqe7EUHY=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [ "-s" "-w" "-X github.com/alajmo/mani/cmd.version=${version}" ];

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
