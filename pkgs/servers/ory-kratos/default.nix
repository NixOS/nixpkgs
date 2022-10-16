{ lib, fetchFromGitHub, stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "ory-kratos";
  version = "0.10.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "ory";
    repo = "kratos";
    sha256 = "sha256-Ld2N7w9jQLkzCww1Sex5nEBZf6e9XIUnbfPOjcFAYQA=";
  };

  buildInputs = [ pkgs.go ];

  buildPhase = ''
    export HOME=$TMPDIR
    export CGO_ENABLED=0
    go build -o bin/kratos main.go
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/kratos $out/bin/kratos
  '';

  postInstall = ''
    installShellCompletion --cmd kratos \
      --bash <($out/bin/kratos completion bash) \
      --fish <($out/bin/kratos completion fish) \
      --zsh <($out/bin/kratos completion zsh)
  '';

  meta = with lib; {
    description = "Next-gen identity server";
    homepage = "https://www.ory.sh/kratos/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabius ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
