{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  netlify-cli,
}:

buildGoModule rec {
  pname = "esbuild";
  version = "0.14.39";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "esbuild";
    rev = "5faa7ad54c99a953d05c06819298d2b6f8c82d80";
    sha256 = "pYiwGjgFMclPYTW0Qml7Pr/knT1gywUAGANra5aojYM=";
  };

  vendorHash = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";

  passthru = {
    tests = {
      inherit netlify-cli;
    };
  };

  meta = with lib; {
    description = "A fork of esbuild maintained by netlify";
    homepage = "https://github.com/netlify/esbuild";
    license = licenses.mit;
    maintainers = with maintainers; [ roberth ];
    mainProgram = "esbuild";
  };
}
