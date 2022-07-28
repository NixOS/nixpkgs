{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.14.50";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "sha256-hW57Ey+2wr7p2ilsMp0luSTOD8aABPpI7GuP0xS7HfY=";
  };

  vendorSha256 = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";

  subPackages = [ "cmd/esbuild" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 marsam ];
  };
}
