{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.16.13";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    hash = "sha256-X4UB2RDfupUP+u+4g2jLxbpx4n4uarhcjs5VtP9Zi20=";
  };

  vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";

  subPackages = [ "cmd/esbuild" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    changelog = "https://github.com/evanw/esbuild/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 marsam ];
  };
}
