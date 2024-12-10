{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tyson";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = "tyson";
    rev = "v${version}";
    hash = "sha256-c4ROLn+BSX7v/4C9/IeU6HiE2YvnqDuXXGp2iZhAVk4=";
  };

  vendorHash = "sha256-NhDv7oH8LK/vebwjs55tsCCWVhbZZd15z5ewOF5z9+Y=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installShellCompletion --cmd tyson \
      --bash <($out/bin/tyson completion bash) \
      --fish <($out/bin/tyson completion fish) \
      --zsh <($out/bin/tyson completion zsh)
  '';

  meta = with lib; {
    description = "TypeScript as a configuration language";
    mainProgram = "tyson";
    homepage = "https://github.com/jetpack-io/tyson";
    changelog = "https://github.com/jetpack-io/tyson/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
