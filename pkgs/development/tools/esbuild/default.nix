{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    hash = "sha256-hqp5K+FOS+UzwIkUTLrw+q4PIQ9OV+8OKKx6wgXBnI0=";
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
