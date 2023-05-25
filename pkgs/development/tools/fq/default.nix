{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testers
}:

buildGoModule rec {
  pname = "fq";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    hash = "sha256-j7s9oluNtYi6MmTKCendTIjc/zvynY6fWvXH47XkwOI=";
  };

  vendorHash = "sha256-XobOcG5s2ggTk3RmJPM14OWv45PMyKs0w0BOvozUobw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
