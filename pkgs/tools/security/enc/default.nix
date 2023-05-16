{ lib
, buildGoModule
, fetchFromGitHub
, git
, installShellFiles
}:

buildGoModule rec {
  pname = "enc";
<<<<<<< HEAD
  version = "1.1.2";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "life4";
    repo = "enc";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-kVK/+pR3Rzg7oCjHKr+i+lK6nhqlBN6Wj92i4SKU2l0=";
  };

  vendorHash = "sha256-6LNo4iBZDc0DTn8f/2PdCb6CNFCjU6o1xDkB5m/twJk=";
=======
    rev = "v${version}";
    sha256 = "Tt+J/MnYJNewSl5UeewS0b47NGW2yzfcVHA5+9UQWSs=";
  };
  vendorSha256 = "lB6GkE6prfBG7OCOJ1gm23Ee5+nAgmJg8I9Nqe1fsRw=";

  proxyVendor = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
