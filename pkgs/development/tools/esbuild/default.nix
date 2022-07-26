{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.14.49";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "sha256-bQt9dLkwvXT4pLxTwYp+5Bg6IgwBnB8uu1gdAmhPn0A=";
  };

  vendorSha256 = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";

  subPackages = [ "cmd/esbuild" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 marsam ];
  };
}
