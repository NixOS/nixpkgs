{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "nfpm";
<<<<<<< HEAD
  version = "2.32.0";
=======
  version = "2.28.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qxxa7V96cJJLu9Ki2NL5UreRyiR9sPhIVA9cllF4y70=";
  };

  vendorHash = "sha256-lVejUufXI5Ihv7hU1N8/MHrwUgIfaHmcj1MR0RTsKVU=";
=======
    sha256 = "sha256-KF/R0DearjiBtgmqM1NQxD8LKLNkly23t8CLDxkfqbk=";
  };

  vendorHash = "sha256-IcV/kXXvs/680zaeS/IQyW2aLTq1O73DEP+32cKXWnU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let emulator = stdenv.hostPlatform.emulator buildPackages;
    in ''
      ${emulator} $out/bin/nfpm man > nfpm.1
      installManPage ./nfpm.1
      installShellCompletion --cmd nfpm \
        --bash <(${emulator} $out/bin/nfpm completion bash) \
        --fish <(${emulator} $out/bin/nfpm completion fish) \
        --zsh  <(${emulator} $out/bin/nfpm completion zsh)
    '';

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
<<<<<<< HEAD
    changelog = "https://github.com/goreleaser/nfpm/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ marsam techknowlogick caarlos0 ];
    license = with licenses; [ mit ];
  };
}
