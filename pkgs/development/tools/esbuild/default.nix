{ buildGoModule, fetchFromGitHub, lib, esbuild, testVersion }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "sha256-ou1fkmlychf6VbKQD/PT1ehfyIQMIpbwEKlxpfncfEo=";
  };

  vendorSha256 = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";

  passthru.tests.version = testVersion { package = esbuild; };

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 ];
  };
}
