{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nix-update-script
, testers
, minify
}:

buildGoModule rec {
  pname = "minify";
  version = "2.12.7";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V3lFM58ciU9RrIp5s+ZMaCUAfRJxbTuQxusXhLCiGmI=";
  };

  patches = [ ./update-go-version-mod.patch ];

  vendorHash = "sha256-v3ZPaeE1YW9BRXHxGsmN8tHv3ApOY+NivfePctOmYlM=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  subPackages = [ "cmd/minify" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = minify;
      command = "minify --version";
    };
  };

  postInstall = ''
    installShellCompletion --cmd minify --bash cmd/minify/bash_completion
  '';

  meta = with lib; {
    description = "Go minifiers for web formats";
    homepage = "https://go.tacodewolff.nl/minify";
    downloadPage = "https://github.com/tdewolff/minify";
    changelog = "https://github.com/tdewolff/minify/releases/tag/v${version}";
    license = licenses.mit;
  };
}
