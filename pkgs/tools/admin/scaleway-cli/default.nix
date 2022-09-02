{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "sha256-C7hCTDs6XLLQPUojqCJEkdSeANrW3XwfFJscSefe0OQ=";
  };

  vendorSha256 = "sha256-NUifjoMP3AmT7RjhkilGmQTMtl5wcuPJL5I32/M27a8=";

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
    "-X main.Version=${version}"
    "-X main.GitCommit=ref/tags/${version}"
    "-X main.GitBranch=HEAD"
    "-X main.BuildDate=unknown"
  ];

  # some tests require network access to scaleway's API, failing when sandboxed
  doCheck = false;

  meta = with lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
