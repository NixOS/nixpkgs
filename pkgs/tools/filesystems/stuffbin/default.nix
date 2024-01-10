{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stuffbin";
  version = "1.2.0";

  vendorHash = null;

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "stuffbin";
    rev = "v${version}";
    sha256 = "sha256-roXjE0t4iwrL2y/G2oePYL2AbTwd9uzQPtgdY14WeZk=";
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
