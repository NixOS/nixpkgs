{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
    hash = "sha256-TxHfgi3/Q4aa5of29OGTs1Qy5PPIK4Gcwd11KJ70NIc=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/build.Version=${version}"
  ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-XeoQI5Rel0qP9cjguPqne7pfNdQJKN+uHRZGnrIGtHk=";

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
