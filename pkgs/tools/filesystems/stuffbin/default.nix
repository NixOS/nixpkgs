{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stuffbin";
  version = "1.3.0";

  vendorHash = null;

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "stuffbin";
    rev = "v${version}";
    sha256 = "sha256-dOlc/G2IiuMAN0LqiZtbpXLSYaOpe5cl1+cs3YhaAbg=";
  };

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Compress and embed static files and assets into Go binaries and access them with a virtual file system in production";
    homepage = "https://github.com/knadh/stuffbin";
    changelog = "https://github.com/knadh/stuffbin/releases/tag/v${version}";
    maintainers = with maintainers; [ raitobezarius ];
    license = licenses.mit;
  };
}
