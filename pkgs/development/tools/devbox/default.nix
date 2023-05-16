{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
}:
buildGoModule rec {
  pname = "devbox";
<<<<<<< HEAD
  version = "0.5.11";
=======
  version = "0.4.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-eJpB1hZu6AGFE86uj2RAaoKHAwivwQhQNimFMglpBLM=";
=======
    hash = "sha256-JxpvUlBrC00zLEZAVVhNI0lP/whd61DcY+NZAoKR55I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/internal/build.Version=${version}"
  ];

  # integration tests want file system access
  doCheck = false;

<<<<<<< HEAD
  vendorHash = "sha256-UTGngCsiqMjxQSdA3QMA/fPC3k+OrjqJ1Q6stXerjQQ=";
=======
  vendorHash = "sha256-Ct1hftgMYAF8DPdnYTB1QQYD0HGC4wifIbMX+TrgDdk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd devbox \
      --bash <($out/bin/devbox completion bash) \
      --fish <($out/bin/devbox completion fish) \
      --zsh <($out/bin/devbox completion zsh)
  '';

  meta = with lib; {
    description = "Instant, easy, predictable shells and containers.";
    homepage = "https://www.jetpack.io/devbox";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
