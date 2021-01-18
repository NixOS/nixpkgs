{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "15njzwvsl7jc2hgxlpsksmn7md3bqpavzaskfdlmzxnxp3biw3cj";
  };

  modRoot = "./cmd";

  vendorSha256 = "1vbydwj3xrz2gimwfasiqiwzsdiplaq7imildzr4wspkk64dprf4";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/google/cadvisor/version.Version=${version}" ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  preCheck = ''
    rm internal/container/mesos/handler_test.go
  '';

  meta = with lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = "https://github.com/google/cadvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
