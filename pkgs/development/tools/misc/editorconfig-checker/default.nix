{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = version;
    sha256 = "sha256-aTHY9RFFkpTQKv+Erczu5joqvE7L05Ev2GOSiXNxLj8=";
  };

  vendorSha256 = "sha256-y+wQ6XzX4vmKzesUcF9jgfrKPj5EsCuw/aKizVX/ogI=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-ldflags=-X main.version=${version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva zowoq ];
  };
}
