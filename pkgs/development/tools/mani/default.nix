{ buildGoModule, fetchFromGitHub, lib, installShellFiles, git, makeWrapper}:

buildGoModule rec {
  pname = "mani";
<<<<<<< HEAD
  version = "0.25.0";
=======
  version = "0.23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "alajmo";
    repo = "mani";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TqxoU2g4ZegJGHrnNO+ivPu209NDFcLnxpHGj8pOA4E=";
  };

  vendorHash = "sha256-mFan09oJ+BPVJHAxoROj282WJ+4e7TD0ZqeQH1kDabQ=";
=======
    sha256 = "sha256-PuoGuweuDcSM1qfjXABSdoqbMLc5a+lYGFr0kZZkgVE=";
  };

  vendorHash = "sha256-9DP6SRcvHtZhkk2XoYesC1mhfq06KsLs0X02AG9vwJ8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
