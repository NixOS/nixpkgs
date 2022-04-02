{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.14.28";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "sha256-Z4Na4Tp5zNbzrOH14t+3rUTL8Q9OfyE6mUAdnETzFrs=";
  };

  vendorSha256 = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 ];
  };
}
