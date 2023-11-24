{ lib
, buildGoModule
, fetchFromGitHub
, git
, installShellFiles
}:

buildGoModule rec {
  pname = "enc";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "life4";
    repo = "enc";
    rev = version;
    hash = "sha256-kVK/+pR3Rzg7oCjHKr+i+lK6nhqlBN6Wj92i4SKU2l0=";
  };

  vendorHash = "sha256-6LNo4iBZDc0DTn8f/2PdCb6CNFCjU6o1xDkB5m/twJk=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/life4/enc/version.GitCommit=${version}"
  ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    installShellCompletion --cmd enc \
      --bash <($out/bin/enc completion bash) \
      --fish <($out/bin/enc completion fish) \
      --zsh <($out/bin/enc completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/life4/enc";
    changelog = "https://github.com/life4/enc/releases/tag/v${version}";
    description = "A modern and friendly alternative to GnuPG";
    longDescription = ''
      Enc is a CLI tool for encryption, a modern and friendly alternative to GnuPG.
      It is easy to use, secure by default and can encrypt and decrypt files using password or encryption keys,
      manage and download keys, and sign data.
      Our goal was to make encryption available to all engineers without the need to learn a lot of new words, concepts,
      and commands. It is the most beginner-friendly CLI tool for encryption, and keeping it that way is our top priority.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ rvnstn ];
  };
}
