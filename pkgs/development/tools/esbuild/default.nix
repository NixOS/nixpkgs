{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.19.5";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    hash = "sha256-mIXsPj804jxDd8+jPH8tWnnUj7dXIRwfKTeT4WDWb5c=";
  };

  vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";

  subPackages = [ "cmd/esbuild" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    changelog = "https://github.com/evanw/esbuild/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 marsam undefined-moe ];
    mainProgram = "esbuild";
  };
}
