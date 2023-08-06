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
  version = "2.12.8";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5p1HWXx9kKKaiC0dTQDd1JpRDhKkDGdnDpuz+I0kgpo=";
  };

  vendorHash = "sha256-RBBCcqahIF1KjnK/Kxr0TZlRJirFffo9Dt40gNk5EQE=";

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
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
